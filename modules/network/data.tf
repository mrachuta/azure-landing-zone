data "azurerm_resource_group" "pfmnet_resource_group_name" {
  name = var.pfmnet_resource_group_name
}

data "azurerm_resource_group" "pfmnet_projects_network_configuration" {
  for_each = { for p in var.pfmnet_projects_network_configuration : p.project_id => p }
  name     = lookup(each.value, "resource_group_name", null)
}
