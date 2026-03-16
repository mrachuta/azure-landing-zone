module "management" {
  source = "../modules/management"

  providers = {
    azurerm = azurerm.pfmmgmt
  }

  pfmmgmt_client_id                   = var.pfmmgmt_client_id
  pfmmgmt_client_certificate_path     = var.pfmmgmt_client_certificate_path
  pfmmgmt_client_certificate_password = var.pfmmgmt_client_certificate_password
  pfmmgmt_tenant_id                   = var.pfmmgmt_tenant_id
  pfmmgmt_subscription_id             = var.pfmmgmt_subscription_id

  pfmmgmt_budget_name                             = var.pfmmgmt_budget_name
  pfmmgmt_budget_monthly_amount                   = var.pfmmgmt_budget_monthly_amount
  pfmmgmt_budget_start_date                       = var.pfmmgmt_budget_start_date
  pfmmgmt_budget_end_date                         = var.pfmmgmt_budget_end_date
  pfmmgmt_budget_notification_contact_emails      = var.pfmmgmt_budget_notification_contact_emails
  pfmmgmt_allowed_locations                       = var.pfmmgmt_allowed_locations
  pfmmgmt_platform_location                       = var.pfmmgmt_platform_location
  pfmmgmt_deny_public_ip_exclusions               = var.pfmmgmt_deny_public_ip_exclusions
  pfmmgmt_platform_management_resource_group_name = var.pfmmgmt_platform_management_resource_group_name
  pfmmgmt_platform_identity_resource_group_tags   = var.pfmmgmt_platform_identity_resource_group_tags
  pfmmgmt_platform_identity_resource_group_name   = var.pfmmgmt_platform_identity_resource_group_name
  pfmmgmt_platform_management_resource_group_tags = var.pfmmgmt_platform_management_resource_group_tags
  pfmmgmt_platform_security_resource_group_name   = var.pfmmgmt_platform_security_resource_group_name
  pfmmgmt_platform_networking_resource_group_name = var.pfmmgmt_platform_networking_resource_group_name
  pfmmgmt_platform_security_resource_group_tags   = var.pfmmgmt_platform_security_resource_group_tags
  pfmmgmt_platform_networking_resource_group_tags = var.pfmmgmt_platform_networking_resource_group_tags
  pfmmgmt_projects_resource_groups                = var.pfmmgmt_projects_resource_groups

}

module "identity" {
  source = "../modules/identity"

  providers = {
    azurerm = azurerm.pfmident
  }
  # depends_on = [module.management]

  pfmident_client_id                   = var.pfmident_client_id
  pfmident_client_certificate_path     = var.pfmident_client_certificate_path
  pfmident_client_certificate_password = var.pfmident_client_certificate_password
  pfmident_tenant_id                   = var.pfmident_tenant_id
  pfmident_subscription_id             = var.pfmident_subscription_id

  pfmident_platform_management_resource_group_name = var.pfmident_platform_management_resource_group_name
  pfmident_platform_identity_resource_group_name   = var.pfmident_platform_identity_resource_group_name
  pfmident_platform_security_resource_group_name   = var.pfmident_platform_security_resource_group_name
  pfmident_platform_networking_resource_group_name = var.pfmident_platform_networking_resource_group_name
  pfmident_groups                                  = var.pfmident_groups
  pfmident_platform_management_team_members        = var.pfmident_platform_management_team_members
  pfmident_platform_identity_team_members          = var.pfmident_platform_identity_team_members
  pfmident_platform_security_team_members          = var.pfmident_platform_networking_team_members
  pfmident_platform_networking_team_members        = var.pfmident_platform_networking_team_members
  pfmident_platform_custom_permissions             = var.pfmident_platform_custom_permissions

}

module "security" {
  source = "../modules/security"

  providers = {
    azurerm = azurerm.pfmsec
  }
  # depends_on = [
  #   module.management,
  #   module.identity
  # ]

  pfmsec_client_id                   = var.pfmsec_client_id
  pfmsec_client_certificate_path     = var.pfmsec_client_certificate_path
  pfmsec_client_certificate_password = var.pfmsec_client_certificate_password
  pfmsec_tenant_id                   = var.pfmsec_tenant_id
  pfmsec_subscription_id             = var.pfmsec_subscription_id

  pfmsec_resource_group_name                            = var.pfmsec_resource_group_name
  pfmsec_security_center_contact_name                   = var.pfmsec_security_center_contact_name
  pfmsec_security_center_contact_email                  = var.pfmsec_security_center_contact_email
  pfmsec_security_center_contact_phone                  = var.pfmsec_security_center_contact_phone
  pfmsec_security_center_resources_and_tiers            = var.pfmsec_security_center_resources_and_tiers
  pfmsec_security_objects_common_tags                   = var.pfmsec_security_objects_common_tags
  pfmsec_audit_logs_analytics_workspace_name            = var.pfmsec_audit_logs_analytics_workspace_name
  pfmsec_audit_logs_analytics_workspace_tags            = var.pfmsec_audit_logs_analytics_workspace_tags
  pfmsec_audit_logs_subscription_audit_log_forward_name = var.pfmsec_audit_logs_subscription_audit_log_forward_name
  pfmsec_key_vault_name                                 = var.pfmsec_key_vault_name
  pfmsec_key_vault_tags                                 = var.pfmsec_key_vault_tags
  pfmsec_default_cmek_admin_groups                      = var.pfmsec_default_cmek_admin_groups
  pfmsec_default_cmek_disk_key                          = var.pfmsec_default_cmek_disk_key

}

module "network" {
  source = "../modules/network"

  providers = {
    azurerm = azurerm.pfmnet
  }
  # depends_on = [
  #   module.management,
  #   module.identity,
  #   module.security
  # ]

  pfmnet_client_id                   = var.pfmnet_client_id
  pfmnet_client_certificate_path     = var.pfmnet_client_certificate_path
  pfmnet_client_certificate_password = var.pfmnet_client_certificate_password
  pfmnet_tenant_id                   = var.pfmnet_tenant_id
  pfmnet_subscription_id             = var.pfmnet_subscription_id

  pfmnet_resource_group_name                         = var.pfmnet_resource_group_name
  pfmnet_hub_objects_common_tags                     = var.pfmnet_hub_objects_common_tags
  pfmnet_hub_network_name                            = var.pfmnet_hub_network_name
  pfmnet_hub_network_tags                            = var.pfmnet_hub_network_tags
  pfmnet_hub_network_address_space                   = var.pfmnet_hub_network_address_space
  pfmnet_hub_network_subnet_gateway_address_prefixes = var.pfmnet_hub_network_subnet_gateway_address_prefixes
  pfmnet_hub_nat_gateway_public_ip_name              = var.pfmnet_hub_nat_gateway_public_ip_name
  pfmnet_hub_nat_gateway_public_ip_tags              = var.pfmnet_hub_nat_gateway_public_ip_tags
  pfmnet_hub_nat_gateway_name                        = var.pfmnet_hub_nat_gateway_name
  pfmnet_hub_nat_gateway_tags                        = var.pfmnet_hub_nat_gateway_tags
  ## Not supported
  # pfmnet_hub_network_subnet_gateway_network_security_group_name  = var.pfmnet_hub_network_subnet_gateway_network_security_group_name
  # pfmnet_hub_network_subnet_gateway_network_security_group_tags  = var.pfmnet_hub_network_subnet_gateway_network_security_group_tags
  # pfmnet_hub_network_subnet_gateway_network_security_group_rules = var.pfmnet_hub_network_subnet_gateway_network_security_group_rules
  pfmnet_hub_network_subnet_nat_name                            = var.pfmnet_hub_network_subnet_nat_name
  pfmnet_hub_network_subnet_nat_address_prefixes                = var.pfmnet_hub_network_subnet_nat_address_prefixes
  pfmnet_hub_network_subnet_nat_default_outbound_access_enabled = var.pfmnet_hub_network_subnet_nat_default_outbound_access_enabled
  pfmnet_hub_network_subnet_nat_network_security_group_name     = var.pfmnet_hub_network_subnet_nat_network_security_group_name
  pfmnet_hub_network_subnet_nat_network_security_group_tags     = var.pfmnet_hub_network_subnet_nat_network_security_group_tags
  pfmnet_hub_network_subnet_nat_network_security_group_rules    = var.pfmnet_hub_network_subnet_nat_network_security_group_rules
  pfmnet_hub_nat_vm_route_table_name                            = var.pfmnet_hub_nat_vm_route_table_name
  pfmnet_hub_nat_route_via_nat_vm_name                          = var.pfmnet_hub_nat_route_via_nat_vm_name
  pfmnet_hub_nat_vm_name                                        = var.pfmnet_hub_nat_vm_name
  pfmnet_hub_nat_vm_tags                                        = var.pfmnet_hub_nat_vm_tags
  pfmnet_hub_nat_vm_private_ip_address                          = var.pfmnet_hub_nat_vm_private_ip_address
  pfmnet_nat_vm_ssh_username                                    = var.pfmnet_nat_vm_ssh_username
  pfmnet_nat_vm_ssh_key_path                                    = var.pfmnet_nat_vm_ssh_key_path
  pfmnet_nat_vm_disk_encryption_set_id                          = var.pfmnet_nat_vm_disk_encryption_set_id
  pfmnet_network_watcher_name                                   = var.pfmnet_network_watcher_name
  pfmnet_network_watcher_tags                                   = var.pfmnet_network_watcher_tags
  pfmnet_hub_virtual_network_gateway_public_ip_name             = var.pfmnet_hub_virtual_network_gateway_public_ip_name
  pfmnet_hub_virtual_network_gateway_public_ip_tags             = var.pfmnet_hub_virtual_network_gateway_public_ip_tags
  pfmnet_hub_virtual_network_gateway_name                       = var.pfmnet_hub_virtual_network_gateway_name
  pfmnet_hub_virtual_network_gateway_tags                       = var.pfmnet_hub_virtual_network_gateway_tags
  pfmnet_hub_local_network_gateway_onprem_name                  = var.pfmnet_hub_local_network_gateway_onprem_name
  pfmnet_hub_local_network_gateway_onprem_tags                  = var.pfmnet_hub_local_network_gateway_onprem_tags
  pfmnet_hub_local_network_gateway_onprem_address               = var.pfmnet_hub_local_network_gateway_onprem_address
  pfmnet_hub_local_network_gateway_onprem_address_space         = var.pfmnet_hub_local_network_gateway_onprem_address_space
  pfmnet_hub_virtual_network_gateway_connection_onprem_name     = var.pfmnet_hub_virtual_network_gateway_connection_onprem_name
  pfmnet_hub_virtual_network_gateway_connection_onprem_tags     = var.pfmnet_hub_virtual_network_gateway_connection_onprem_tags
  pfmnet_hub_virtual_network_gateway_connection_onprem_key      = var.pfmnet_hub_virtual_network_gateway_connection_onprem_key
  pfmnet_projects_network_configuration                         = var.pfmnet_projects_network_configuration

}

