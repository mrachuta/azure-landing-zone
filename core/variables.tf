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
