variable "pfmnet_client_certificate_password" {}
variable "pfmnet_client_certificate_path" {}
variable "pfmnet_client_id" {}
variable "pfmnet_tenant_id" {}
variable "pfmnet_subscription_id" {}

variable "pfmnet_resource_group_name" {
  type    = string
  default = null
}
variable "pfmnet_hub_objects_common_tags" {
  type    = map(string)
  default = {}
}
variable "pfmnet_hub_network_name" {
  type    = string
  default = null
}
variable "pfmnet_hub_network_tags" {
  type    = map(string)
  default = {}
}
variable "pfmnet_hub_network_address_space" {
  type    = list(string)
  default = ["10.10.0.0/16"]
}
variable "pfmnet_hub_network_subnet_gateway_address_prefixes" {
  type    = list(string)
  default = ["10.10.0.0/24"]
}
## Not supported
# variable "pfmnet_hub_network_subnet_gateway_network_security_group_name" {
#   type    = string
#   default = null
# }
# variable "pfmnet_hub_network_subnet_gateway_network_security_group_tags" {
#   type    = map(string)
#   default = {}
# }
# variable "pfmnet_hub_network_subnet_gateway_network_security_group_rules" {
#   type = list(object({
#       name                       = string
#       priority                   = number
#       direction                  = string
#       access                     = string
#       protocol                   = string
#       source_port_range          = string
#       destination_port_range     = string
#       source_address_prefix      = string
#       destination_address_prefix = string
#     }))
#   default  = []
# }
variable "pfmnet_hub_network_subnet_backup_name" {
  type    = string
  default = null
}
variable "pfmnet_hub_network_subnet_backup_address_prefixes" {
  type    = list(string)
  default = ["10.10.1.0/24"]
}
variable "pfmnet_hub_network_subnet_backup_network_security_group_name" {
  type    = string
  default = null
}
variable "pfmnet_hub_network_subnet_backup_network_security_group_tags" {
  type    = map(string)
  default = {}
}
variable "pfmnet_hub_network_subnet_backup_network_security_group_rules" {
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}
variable "pfmnet_network_watcher_name" {
  type    = string
  default = null
}
variable "pfmnet_network_watcher_tags" {
  type    = map(string)
  default = {}
}
variable "pfmnet_hub_virtual_network_gateway_public_ip_name" {
  type    = string
  default = null
}
variable "pfmnet_hub_virtual_network_gateway_public_ip_tags" {
  type    = map(string)
  default = {}
}
variable "pfmnet_hub_virtual_network_gateway_name" {
  type    = string
  default = null
}
variable "pfmnet_hub_virtual_network_gateway_tags" {
  type    = map(string)
  default = {}
}
variable "pfmnet_hub_local_network_gateway_onprem_name" {
  type    = string
  default = null
}
variable "pfmnet_hub_local_network_gateway_onprem_tags" {
  type    = map(string)
  default = {}
}
variable "pfmnet_hub_local_network_gateway_onprem_address" {
  type    = string
  default = null
}
variable "pfmnet_hub_local_network_gateway_onprem_address_space" {
  type    = list(string)
  default = []
}
variable "pfmnet_hub_virtual_network_gateway_connection_onprem_name" {
  type    = string
  default = null
}
variable "pfmnet_hub_virtual_network_gateway_connection_onprem_tags" {
  type    = map(string)
  default = {}
}
variable "pfmnet_hub_virtual_network_gateway_connection_onprem_key" {
  type      = string
  default   = null
  sensitive = true
}
variable "pfmnet_projects_network_configuration" {
  type = list(object({
    project_id                    = string
    resource_group_name           = string
    virtual_network_name          = string
    virtual_network_tags          = map(string)
    virtual_network_address_space = list(string)
    virtual_network_subnets = list(object({
      subnet_name                        = string
      subnet_address_prefixes            = list(string)
      subnet_network_security_group_name = string
      subnet_network_security_group_tags = map(string)
      subnet_network_security_group_rules = list(object({
        name                       = string
        priority                   = number
        direction                  = string
        access                     = string
        protocol                   = string
        source_port_range          = string
        destination_port_range     = string
        source_address_prefix      = string
        destination_address_prefix = string
      }))
    }))
    create_peering = bool
  }))
  default = []
}
