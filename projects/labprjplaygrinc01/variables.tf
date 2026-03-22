variable "client_certificate_password" {}
variable "client_certificate_path" {}
variable "client_id" {}
variable "tenant_id" {}
variable "subscription_id" {}

variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
  default     = "rgmyproject"
}

variable "vm_location" {
  description = "The Azure region for the VM"
  type        = string
  default     = "eastus"
}

variable "vm_name" {
  description = "The name of the VM and its associated resources"
  type        = string
  default     = "vm01"
}

variable "vm_subnet_id" {
  description = "The ID of the subnet where the VM will be deployed"
  type        = string
}

variable "vm_ssh_username" {
  description = "The admin username for the VM"
  type        = string
  default     = "azureuser"
}

variable "vm_ssh_key_path" {
  description = "The local path to the SSH public key file"
  type        = string
}

variable "vm_disk_encryption_set_id" {
  description = "The ID of the Disk Encryption Set to use for the OS disk"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {
    environment = "dev"
    project     = "myproject"
  }
}
