output "pfmmgmt_projects_resource_groups" {
  description = "Map of project resource group names created by the platform management"
  value       = module.management.pfmmgmt_projects_resource_groups
}
