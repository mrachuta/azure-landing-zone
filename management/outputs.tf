output "pfmmgmt_projects_resource_groups" {
  description = "Map of project resource group names created by the platform management"
  value       = { for k, rg in azurerm_resource_group.pfmmgmt_project_resource_group : k => { "resource_group_name" = rg.name, "resource_group_location" = rg.location } }
}

# output "platform_management_resource_group_name" {
#   value = azurerm_resource_group.platform_management_resource_group.name
# }

# output "platform_identity_resource_group_name" {
#   value = azurerm_resource_group.platform_identity_resource_group.name
# }

# output "platform_security_resource_group_name" {
#   value = azurerm_resource_group.platform_security_resource_group.name
# }

# output "platform_networking_resource_group_name" {
#   value = azurerm_resource_group.platform_networking_resource_group.name
# }
