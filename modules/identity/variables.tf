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
