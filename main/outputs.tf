output "projects_resource_groups_names" {
  description = "Map of project resource group names created by the core module"
  value = module.core.projects_resource_groups_names
}
