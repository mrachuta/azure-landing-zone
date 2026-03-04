terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.60"
      configuration_aliases = [
        azurerm,
        azurerm.pfmmgmt,
        azurerm.pfmident,
        azurerm.pfmsec
      ]
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.53"
    }
  }
}

provider "azurerm" {
  features {}
  alias                       = "pfmmgmt"
  client_id                   = var.pfmmgmt_client_id
  client_certificate_path     = var.pfmmgmt_client_certificate_path
  client_certificate_password = var.pfmmgmt_client_certificate_password
  tenant_id                   = var.pfmmgmt_tenant_id
  subscription_id             = var.pfmmgmt_subscription_id
}

provider "azurerm" {
  features {}
  alias                       = "pfmident"
  client_id                   = var.pfmident_client_id
  client_certificate_path     = var.pfmident_client_certificate_path
  client_certificate_password = var.pfmident_client_certificate_password
  tenant_id                   = var.pfmident_tenant_id
  subscription_id             = var.pfmident_subscription_id
}

provider "azuread" {
  client_id                   = var.pfmident_client_id
  client_certificate_path     = var.pfmident_client_certificate_path
  client_certificate_password = var.pfmident_client_certificate_password
  tenant_id                   = var.pfmident_tenant_id
}

provider "azurerm" {
  features {}
  alias                       = "pfmnet"
  client_id                   = var.pfmnet_client_id
  client_certificate_path     = var.pfmnet_client_certificate_path
  client_certificate_password = var.pfmnet_client_certificate_password
  tenant_id                   = var.pfmnet_tenant_id
  subscription_id             = var.pfmnet_subscription_id
}

provider "azurerm" {
  features {}
  alias                       = "pfmsec"
  client_id                   = var.pfmsec_client_id
  client_certificate_path     = var.pfmsec_client_certificate_path
  client_certificate_password = var.pfmsec_client_certificate_password
  tenant_id                   = var.pfmsec_tenant_id
  subscription_id             = var.pfmsec_subscription_id
}