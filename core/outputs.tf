output "projects_resource_groups_names" {
  description = "Map of project resource group names created by the core module"
  value = { for k, rg in azurerm_resource_group.project_resource_group : k => { "resource_group_name" = rg.name } }
}
