variable "client_certificate_password" {

}

variable "client_certificate_path" {

}

variable "client_id" {

}

variable "tenant_id" {

}

variable "subscription_id" {

}

# Core module variables

variable "subscription_budget_name" {

}

variable "subscription_budget_start_date" {
  
}

variable "subscription_budget_end_date" {
  
}

variable "subscription_budget_notification_contact_emails" {
  
}

variable "projects_resource_groups" {
  type = map(object({
    resource_group_name     = string
    resource_group_location = string
    resource_group_tags     = map(string)
  }))
}

# Network module variables

variable "hub_resource_group_name" {
  
}

variable "hub_resource_group_location" {
  
}

variable "hub_network_name" {
  
}

variable "hub_network_address_space" {
  
}

variable "hub_network_subnet_gateway_address_prefixes" {

}

variable "hub_network_subnet_backup_name" {
  
}

variable "hub_network_subnet_backup_address_prefixes" {

}

variable "hub_virtual_network_gateway_public_ip_name" {
  
}


variable "hub_virtual_network_gateway_name" {
  
}

variable "hub_local_network_gateway_onprem_name" {
  
}

variable "hub_local_network_gateway_onprem_address" {
  
}

variable "hub_local_network_gateway_onprem_address_space" {
  
}

variable "hub_virtual_network_gateway_connection_onprem_name" {
  
}

variable "hub_virtual_network_gateway_connection_onprem_key" {
  
}

variable "projects_resource_groups_names" {
  
}

variable "projects_network_configuration" {
  type = map(object({
    virtual_network_name = string
    virtual_network_address_space = list(string)
    virtual_network_subnets = map(object({
      subnet_name = string
      subnet_address_prefixes = list(string)
    }))
    create_peering = bool
  }))
}

# Project module variables dev_playground

variable "project_dev_playground_resource_group_name" {
  
}

variable "project_dev_playground_resource_group_location" {
  
}

variable "project_dev_playground_network_name" {
  
}

## Project-defined

variable "project_dev_playground_vngtest_subnet_name" {
  
}

variable "project_dev_playground_vngtest_vm_name" {
  
}

variable "project_dev_playground_vngtest_network_interface_name" {
  
}

variable "project_dev_playground_vngtest_vm_ssh_public_key_path" {
  
}

variable "project_dev_playground_vngtest_vm_image_details" {
  
}

# Project module variables prd_kubespace

variable "project_prd_kubespace_resource_group_name" {
  
}

variable "project_prd_kubespace_resource_group_location" {
  
}

variable "project_prd_kubespace_network_name" {
  
}

## Project-defined

variable "project_prd_kubespace_vngtest_subnet_name" {
  
}

variable "project_prd_kubespace_vngtest_vm_name" {
  
}

variable "project_prd_kubespace_vngtest_network_interface_name" {
  
}

variable "project_prd_kubespace_vngtest_vm_ssh_public_key_path" {
  
}

variable "project_prd_kubespace_vngtest_vm_image_details" {
  
}
