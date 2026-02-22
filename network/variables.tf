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
  description = "Map of project resource group names from core module"
  type = map(object({
    resource_group_name = string
  }))
  default = {}
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
