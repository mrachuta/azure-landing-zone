data "azurerm_resource_group" "project_resource_group" {
  for_each = var.projects_resource_groups_names
  name                = each.value.resource_group_name
}
