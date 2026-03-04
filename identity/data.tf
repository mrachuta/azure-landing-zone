data "azuread_client_config" "current" {}

data "azurerm_subscription" "primary" {}

data "azuread_user" "pfmident_user" {
  for_each            = local.users
  user_principal_name = lookup(each.value, "name", null)
}

data "azuread_group" "pfmident_group" {
  for_each     = local.groups
  display_name = lookup(each.value, "name", null)
}

data "azuread_service_principal" "pfmident_service_principal" {
  for_each     = local.service_principals
  display_name = lookup(each.value, "name", null)
}

data "azurerm_user_assigned_identity" "pfmident_user_assigned_managed_identity" {
  for_each            = local.user_assigned_managed_identities
  name                = lookup(each.value, "name", null)
  resource_group_name = lookup(each.value, "identity_resource_group", null)
}

data "azurerm_resource_group" "pfmident_platform_management_resource_group" {
  name = var.pfmident_platform_management_resource_group_name
}

data "azurerm_resource_group" "pfmident_platform_identity_resource_group" {
  name = var.pfmident_platform_identity_resource_group_name
}

data "azurerm_resource_group" "pfmident_platform_security_resource_group" {
  name = var.pfmident_platform_security_resource_group_name
}

data "azurerm_resource_group" "pfmident_platform_networking_resource_group" {
  name = var.pfmident_platform_networking_resource_group_name
}
