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
