# TODO: Metrics how many logs were ingested

resource "azurerm_log_analytics_workspace" "pfmsec_audit_logs_analytics_workspace" {
  name                = var.pfmsec_audit_logs_analytics_workspace_name
  location            = data.azurerm_resource_group.pfmsec_resource_group_name.location
  resource_group_name = data.azurerm_resource_group.pfmsec_resource_group_name.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  daily_quota_gb      = -1
  tags                = merge(var.pfmsec_security_objects_common_tags, var.pfmsec_audit_logs_analytics_workspace_tags)
}

resource "azurerm_monitor_diagnostic_setting" "pfmsec_audit_logs_subscription_audit_log_forward" {
  name                       = var.pfmsec_audit_logs_subscription_audit_log_forward_name
  target_resource_id         = data.azurerm_subscription.current.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.pfmsec_audit_logs_analytics_workspace.id

  # For all audit-related
  dynamic "enabled_log" {
    for_each = ["Administrative", "Policy", "Security"]
    content {
      category = enabled_log.value
    }
  }
}

resource "azurerm_key_vault" "pfmsec_key_vault" {
  name                        = var.pfmsec_key_vault_name
  location                    = data.azurerm_resource_group.pfmsec_resource_group_name.location
  resource_group_name         = data.azurerm_resource_group.pfmsec_resource_group_name.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  purge_protection_enabled    = true
  enabled_for_disk_encryption = true
  tags                        = merge(var.pfmsec_security_objects_common_tags, var.pfmsec_key_vault_tags)
}

# resource "azurerm_key_vault_access_policy" "pfmsec_default_cmek_disk_full_permissions_to_group" {
#   key_vault_id = azurerm_key_vault.pfmsec_key_vault.id
#   tenant_id    = data.azurerm_client_config.current.tenant_id
#   object_id    = var.pfmsec_default_cmek_disk_full_permissions_group_name

#   key_permissions = ["Backup", "Create", "Decrypt", "Delete", "Encrypt", "Get", "Import", "List", "Purge", "Recover", "Restore", "Sign", "UnwrapKey", "Update", "Verify", "WrapKey", "Release", "Rotate", "GetRotationPolicy", "SetRotationPolicy"]
# }

resource "azurerm_key_vault_access_policy" "pfmsec_key_vault_full_permissions_to_service_principal" {
  key_vault_id = azurerm_key_vault.pfmsec_key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  certificate_permissions = local.admin_certificate_permissions
  key_permissions = local.admin_key_permissions
  secret_permissions = local.admin_secret_permissions
}

# TODO: move to identity
resource "azurerm_key_vault_access_policy" "pfmsec_key_vault_full_permissions_to_to_admin_groups" {
  for_each     = { for g in var.pfmsec_default_cmek_admin_groups : g.id => g }
  key_vault_id = azurerm_key_vault.pfmsec_key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = each.key

  certificate_permissions = local.admin_certificate_permissions
  key_permissions = local.admin_key_permissions
  secret_permissions = local.admin_secret_permissions
}

resource "azurerm_key_vault_key" "pfmsec_default_cmek_disk_key" {
  for_each     = { for k in var.pfmsec_default_cmek_disk_key : k.name => k }
  name         = lookup(each.value, "name", null)
  key_vault_id = azurerm_key_vault.pfmsec_key_vault.id
  key_type     = "RSA"
  key_size     = 4096
  key_opts     = ["decrypt", "encrypt", "sign", "unwrapKey", "verify", "wrapKey"]

  depends_on = [azurerm_key_vault_access_policy.pfmsec_key_vault_full_permissions_to_service_principal]
  tags       = merge(var.pfmsec_security_objects_common_tags, lookup(each.value, "tags", null))
}

resource "azurerm_disk_encryption_set" "pfmsec_default_cmek_disk" {
  for_each            = { for k in var.pfmsec_default_cmek_disk_key : k.name => k }
  name                = lookup(each.value, "disk_encryption_set_name", null)
  key_vault_key_id    = azurerm_key_vault_key.pfmsec_default_cmek_disk_key[each.key].id
  location            = data.azurerm_resource_group.pfmsec_resource_group_name.location
  resource_group_name = data.azurerm_resource_group.pfmsec_resource_group_name.name
  tags                = merge(var.pfmsec_security_objects_common_tags, lookup(each.value, "disk_encryption_set_tags", null))

  identity {
    type = "SystemAssigned"
  }

  depends_on = [azurerm_key_vault_access_policy.pfmsec_key_vault_full_permissions_to_service_principal]
}

resource "azurerm_key_vault_access_policy" "pfmsec_default_cmek_disk_user_to_identity" {
  for_each     = { for k in var.pfmsec_default_cmek_disk_key : k.name => k }
  key_vault_id = azurerm_key_vault.pfmsec_key_vault.id
  tenant_id    = azurerm_disk_encryption_set.pfmsec_default_cmek_disk[each.key].identity[0].tenant_id
  object_id    = azurerm_disk_encryption_set.pfmsec_default_cmek_disk[each.key].identity[0].principal_id

  key_permissions = ["Get", "WrapKey", "UnwrapKey"]
}

resource "azurerm_security_center_contact" "pfmsec_security_center_contact" {
  name  = var.pfmsec_security_center_contact_name
  email = var.pfmsec_security_center_contact_email
  phone = var.pfmsec_security_center_contact_phone

  alert_notifications = true
  alerts_to_admins    = true
}

resource "azurerm_security_center_subscription_pricing" "pfmsec_security_center_resources" {
  for_each = { for s in var.pfmsec_security_center_resources_and_tiers : s.resource_type => s }

  resource_type = lookup(each.value, "resource_type", null)
  tier          = lookup(each.value, "tier", null)
}
