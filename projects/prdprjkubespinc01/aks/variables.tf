variable "client_certificate_password" {}
variable "client_certificate_path" {}
variable "client_id" {}
variable "tenant_id" {}
variable "subscription_id" {}

variable "existing_rg" {
  type        = string
  default     = "myexistingrg01"
}

variable "extra_tags" {
  type        = map(string)
  default     = {}
}

variable "acr_provision" {
  type        = bool
  default     = true
}

variable "acr_name" {
  type        = string
  default     = "myacr01"
}

variable "acr_custom_region" {
  type        = string
  default     = null
}

variable "acr_grant_pull_role_to_aks" {
  type        = bool
  default     = false
}

variable "aks_provision" {
  type        = bool
  default     = true
}

variable "aks_name" {
  type        = string
  default     = "myaks01"
}

variable "aks_custom_region" {
  type        = string
  default     = null
}

variable "aks_managed_identity_name" {
  type    = string
  default = "myaks01_uami"
}

variable "aks_resources_rg_name" {
  type        = string
  default     = "myacr01_rg"
}

variable "aks_outbound_type" {
  type        = string
  default     = "loadBalancer"
}

variable "aks_nodes_extra_tags" {
  type        = map(string)
  default     = {}
}

variable "aks_api_server_subnetwork_id" {
  type    = string
  default = null
}

variable "aks_node_pool_subnetwork_id" {
  type    = string
  default = null
}

variable "aks_auth_ip_ranges" {
  type        = list(string)
  default     = []
}

variable "aks_node_count" {
  type        = number
  default     = 1
}

variable "aks_disk_encryption_set_id" {
  type        = string
  default     = null
}


variable "aks_node_sku" {
  type        = string
  default     = "Standard_B2s"
}

variable "aks_enable_spot_node_pool" {
  type        = bool
  default     = false
}

variable "aks_spot_node_pool_config" {
  type = object({
    name  = string
    sku   = string
    count = number
  })
  default = null
}

variable "contapp_provision" {
  type        = bool
  default     = false
}

variable "contapp_env_name" {
  type        = string
  default     = "mycontappenv01"
}

variable "contapp_nginx_ingress_additional_params" {
  type        = map(string)
  default     = {}
}

variable "aks_enable_default_node_pool_autoscaling_to_zero" {
  type        = bool
  default     = false
}

variable "aks_default_node_pool_autoscaling_to_zero_details" {
  type = object({
    days          = list(string)
    start_time_HH = number
    start_time_MM = number
    stop_time_HH  = number
    stop_time_MM  = number
    timezone      = string
  })
  default     = null
}

variable "aks_enable_spot_node_pool_autoscaling" {
  type        = bool
  default     = false
}

variable "aks_spot_node_pool_autoscaling_details" {
  type = object({
    days          = list(string)
    start_time_HH = number
    start_time_MM = number
    stop_time_HH  = number
    stop_time_MM  = number
    timezone      = string
    capacity      = number
  })
  default     = null
}

variable "az_cli_path" {
  type        = string
  default     = "az"
}

variable "provisioner_arm_client_secret" {
  type    = string
  default = null
}
