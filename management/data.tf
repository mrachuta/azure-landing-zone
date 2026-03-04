data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

data "azurerm_policy_definition" "pfmmgmt_allowed_locations" {
  display_name = "Allowed locations"
}

data "azurerm_policy_definition" "pfmmgmt_require_tag" {
  display_name = "Require a tag on resources"
}

data "azurerm_policy_definition" "pfmgmt_secure_transfer_storage" {
  display_name = "Secure transfer to storage accounts should be enabled"
}
