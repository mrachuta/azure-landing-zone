variable "pfmsec_client_certificate_password" {}
variable "pfmsec_client_certificate_path" {}
variable "pfmsec_client_id" {}
variable "pfmsec_tenant_id" {}
variable "pfmsec_subscription_id" {}

variable "pfmsec_resource_group_name" {}
variable "pfmsec_security_objects_common_tags" {}
variable "pfmsec_audit_logs_analytics_workspace_name" {}
variable "pfmsec_audit_logs_analytics_workspace_tags" {}
variable "pfmsec_audit_logs_subscription_audit_log_forward_name" {}
variable "pfmsec_key_vault_name" {}
variable "pfmsec_key_vault_tags" {}
variable "pfmsec_default_cmek_disk_key" {
  type = list(object({
    name                     = string
    tags                     = map(string)
    disk_encryption_set_name = string
    disk_encryption_set_tags = map(string)
  }))
}
variable "pfmsec_security_center_contact_name" {}
variable "pfmsec_security_center_contact_email" {}
variable "pfmsec_security_center_contact_phone" {}
variable "pfmsec_security_center_resources_and_tiers" {
  type = list(object({
    resource_type = string
    tier          = string
  }))
}
