### Management module variables

variable "pfmmgmt_client_certificate_password" {}
variable "pfmmgmt_client_certificate_path" {}
variable "pfmmgmt_client_id" {}
variable "pfmmgmt_tenant_id" {}
variable "pfmmgmt_subscription_id" {}

variable "pfmmgmt_budget_name" {
  type    = string
  default = "bud-prd-pfmmgmt-global-01"
}
variable "pfmmgmt_budget_monthly_amount" {
  type    = number
  default = 30
}
variable "pfmmgmt_budget_start_date" {
  type    = string
  default = null
}
variable "pfmmgmt_budget_end_date" {
  type    = string
  default = null
}
variable "pfmmgmt_budget_notification_contact_emails" {
  type    = list(string)
  default = []
}
variable "pfmmgmt_allowed_locations" {
  type    = list(string)
  default = ["northcentralus", "eastus"]
}
variable "pfmmgmt_platform_location" {
  type    = string
  default = "eastus"
}
variable "pfmmgmt_deny_public_ip_exclusions" {
  type    = list(string)
  default = []
}
variable "pfmmgmt_platform_management_resource_group_name" {
  type    = string
  default = null
}
variable "pfmmgmt_platform_management_resource_group_tags" {
  type    = map(string)
  default = {}
}
variable "pfmmgmt_platform_identity_resource_group_name" {
  type    = string
  default = null
}
variable "pfmmgmt_platform_identity_resource_group_tags" {
  type    = map(string)
  default = {}
}
variable "pfmmgmt_platform_security_resource_group_name" {
  type    = string
  default = null
}
variable "pfmmgmt_platform_security_resource_group_tags" {
  type    = map(string)
  default = {}
}
variable "pfmmgmt_platform_networking_resource_group_name" {
  type    = string
  default = null
}
variable "pfmmgmt_platform_networking_resource_group_tags" {
  type    = map(string)
  default = {}
}
variable "pfmmgmt_projects_resource_groups" {
  type = list(object({
    project_id              = string
    resource_group_name     = string
    resource_group_location = string
    resource_group_tags     = map(string)
  }))
  default = []
}

### Identity module variables

variable "pfmident_client_certificate_password" {}
variable "pfmident_client_certificate_path" {}
variable "pfmident_client_id" {}
variable "pfmident_tenant_id" {}
variable "pfmident_subscription_id" {}

variable "pfmident_platform_management_resource_group_name" {
  type    = string
  default = null
}
variable "pfmident_platform_identity_resource_group_name" {
  type    = string
  default = null
}
variable "pfmident_platform_security_resource_group_name" {
  type    = string
  default = null
}
variable "pfmident_platform_networking_resource_group_name" {
  type    = string
  default = null
}
variable "pfmident_groups" {
  type = list(object({
    name        = string
    description = string
  }))
  default = []
}
variable "pfmident_platform_management_team_members" {
  type = list(object({
    type                    = string
    name                    = string
    identity_resource_group = optional(string)
  }))
  default = []
}
variable "pfmident_platform_identity_team_members" {
  type = list(object({
    type                    = string
    name                    = string
    identity_resource_group = optional(string)
  }))
  default = []
}
variable "pfmident_platform_security_team_members" {
  type = list(object({
    type                    = string
    name                    = string
    identity_resource_group = optional(string)
  }))
  default = []
}
variable "pfmident_platform_networking_team_members" {
  type = list(object({
    type                    = string
    name                    = string
    identity_resource_group = optional(string)
  }))
  default = []
}
variable "pfmident_platform_custom_permissions" {
  type = list(object({
    type                    = string
    name                    = string
    identity_resource_group = optional(string)
    role_definition_name    = string
    scope                   = string
  }))
  default = []
}

### Security module variables

variable "pfmsec_client_certificate_password" {}
variable "pfmsec_client_certificate_path" {}
variable "pfmsec_client_id" {}
variable "pfmsec_tenant_id" {}
variable "pfmsec_subscription_id" {}

variable "pfmsec_resource_group_name" {
  type    = string
  default = null
}
variable "pfmsec_security_objects_common_tags" {
  type    = map(string)
  default = {}
}
variable "pfmsec_audit_logs_analytics_workspace_name" {
  type    = string
  default = null
}
variable "pfmsec_audit_logs_analytics_workspace_tags" {
  type    = map(string)
  default = {}
}
variable "pfmsec_audit_logs_subscription_audit_log_forward_name" {
  type    = string
  default = null
}
variable "pfmsec_key_vault_name" {
  type    = string
  default = null
}
variable "pfmsec_key_vault_tags" {
  type    = map(string)
  default = {}
}
variable "pfmsec_default_cmek_admin_groups" {
  type = list(object({
    id = string
  }))
  default = []
}
variable "pfmsec_default_cmek_disk_key" {
  type = list(object({
    name                     = string
    tags                     = map(string)
    disk_encryption_set_name = string
    disk_encryption_set_tags = map(string)
  }))
}
variable "pfmsec_security_center_contact_name" {
  type    = string
  default = null
}
variable "pfmsec_security_center_contact_email" {
  type    = string
  default = null
}
variable "pfmsec_security_center_contact_phone" {
  type    = string
  default = null
}
variable "pfmsec_security_center_resources_and_tiers" {
  type = list(object({
    resource_type = string
    tier          = string
  }))
  default = [
    {
      resource_type = "StorageAccounts",
      tier          = "Free"
    },
    {
      resource_type = "VirtualMachines",
      tier          = "Free"
    }
  ]
}

### Network module variables

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
variable "pfmnet_hub_nat_gateway_public_ip_name" {
  type    = string
  default = null
}
variable "pfmnet_hub_nat_gateway_public_ip_tags" {
  type    = map(string)
  default = {}
}
variable "pfmnet_hub_nat_gateway_name" {
  type    = string
  default = null
}
variable "pfmnet_hub_nat_gateway_tags" {
  type    = map(string)
  default = {}
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
variable "pfmnet_hub_network_subnet_nat_name" {
  type    = string
  default = null
}
variable "pfmnet_hub_network_subnet_nat_address_prefixes" {
  type    = list(string)
  default = ["10.10.1.0/24"]
}
variable "pfmnet_hub_network_subnet_nat_default_outbound_access_enabled" {
  type    = bool
  default = true
}
variable "pfmnet_hub_network_subnet_nat_network_security_group_name" {
  type    = string
  default = null
}
variable "pfmnet_hub_network_subnet_nat_network_security_group_tags" {
  type    = map(string)
  default = {}
}
variable "pfmnet_hub_network_subnet_nat_network_security_group_rules" {
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
variable "pfmnet_hub_nat_vm_route_table_name" {
  type    = string
  default = null
}
variable "pfmnet_hub_nat_route_via_nat_vm_name" {
  type    = string
  default = null
}
variable "pfmnet_hub_nat_vm_name" {
  type    = string
  default = null
}
variable "pfmnet_hub_nat_vm_tags" {
  type    = map(string)
  default = {}
}
variable "pfmnet_hub_nat_vm_private_ip_address" {
  type    = string
  default = null
}
variable "pfmnet_nat_vm_ssh_username" {
  type    = string
  default = null
}
variable "pfmnet_nat_vm_ssh_key_path" {
  type    = string
  default = null
}
variable "pfmnet_nat_vm_disk_encryption_set_id" {
  type    = string
  default = null
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
      subnet_name                            = string
      subnet_address_prefixes                = list(string)
      subnet_default_outbound_access_enabled = bool
      subnet_nat_gateway_association         = bool
      subnet_route_via_nat_vm                = bool
      subnet_network_security_group_name     = string
      subnet_network_security_group_tags     = map(string)
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

