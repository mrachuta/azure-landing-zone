data "azurerm_subscription" "current" {}

data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "pfmsec_resource_group_name" {
  name = var.pfmsec_resource_group_name
}
