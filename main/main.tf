module "core" {
  source = "../core"

  client_id                   = var.client_id
  client_certificate_path     = var.client_certificate_path
  client_certificate_password = var.client_certificate_password
  tenant_id                   = var.tenant_id
  subscription_id             = var.subscription_id

  subscription_budget_name                        = var.subscription_budget_name
  subscription_budget_start_date                  = var.subscription_budget_start_date
  subscription_budget_end_date                    = var.subscription_budget_end_date
  subscription_budget_notification_contact_emails = var.subscription_budget_notification_contact_emails

  projects_resource_groups = var.projects_resource_groups
}

module "network" {
  source = "../network"

  client_id                   = var.client_id
  client_certificate_path     = var.client_certificate_path
  client_certificate_password = var.client_certificate_password
  tenant_id                   = var.tenant_id
  subscription_id             = var.subscription_id

  hub_resource_group_name                            = var.hub_resource_group_name
  hub_resource_group_location                        = var.hub_resource_group_location
  hub_network_name                                   = var.hub_network_name
  hub_network_address_space                          = var.hub_network_address_space
  hub_network_subnet_backup_name                     = var.hub_network_subnet_backup_name
  hub_network_subnet_backup_address_prefixes         = var.hub_network_subnet_backup_address_prefixes
  hub_network_subnet_gateway_address_prefixes        = var.hub_network_subnet_gateway_address_prefixes
  hub_virtual_network_gateway_public_ip_name         = var.hub_virtual_network_gateway_public_ip_name
  hub_virtual_network_gateway_name                   = var.hub_virtual_network_gateway_name
  hub_local_network_gateway_onprem_name              = var.hub_local_network_gateway_onprem_name
  hub_local_network_gateway_onprem_address           = var.hub_local_network_gateway_onprem_address
  hub_local_network_gateway_onprem_address_space     = var.hub_local_network_gateway_onprem_address_space
  hub_virtual_network_gateway_connection_onprem_name = var.hub_virtual_network_gateway_connection_onprem_name
  hub_virtual_network_gateway_connection_onprem_key  = var.hub_virtual_network_gateway_connection_onprem_key

  projects_resource_groups_names = module.core.projects_resource_groups_names
  projects_network_configuration = var.projects_network_configuration

}

module "project_dev_playground" {
  source = "../project"

  client_id                   = var.client_id
  client_certificate_path     = var.client_certificate_path
  client_certificate_password = var.client_certificate_password
  tenant_id                   = var.tenant_id
  subscription_id             = var.subscription_id

  project_resource_group_name     = var.project_dev_playground_resource_group_name
  project_resource_group_location = var.project_dev_playground_resource_group_location
  project_network_name            = var.project_dev_playground_network_name

  vngtest_subnet_name            = var.project_dev_playground_vngtest_subnet_name
  vngtest_vm_name                = var.project_dev_playground_vngtest_vm_name
  vngtest_network_interface_name = var.project_dev_playground_vngtest_network_interface_name
  vngtest_vm_ssh_public_key_path = var.project_dev_playground_vngtest_vm_ssh_public_key_path
  vngtest_vm_image_details       = var.project_dev_playground_vngtest_vm_image_details
}

module "project_prd_kubespace" {
  source = "../project"

  client_id                   = var.client_id
  client_certificate_path     = var.client_certificate_path
  client_certificate_password = var.client_certificate_password
  tenant_id                   = var.tenant_id
  subscription_id             = var.subscription_id

  project_resource_group_name     = var.project_prd_kubespace_resource_group_name
  project_resource_group_location = var.project_prd_kubespace_resource_group_location
  project_network_name            = var.project_prd_kubespace_network_name

  vngtest_subnet_name            = var.project_prd_kubespace_vngtest_subnet_name
  vngtest_vm_name                = var.project_prd_kubespace_vngtest_vm_name
  vngtest_network_interface_name = var.project_prd_kubespace_vngtest_network_interface_name
  vngtest_vm_ssh_public_key_path = var.project_prd_kubespace_vngtest_vm_ssh_public_key_path
  vngtest_vm_image_details       = var.project_prd_kubespace_vngtest_vm_image_details
}
