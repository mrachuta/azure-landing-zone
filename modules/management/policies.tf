resource "azurerm_policy_definition" "pfmmgmt_allowed_locations" {
  name         = "pde-prd-pfmmgmt-allowed-locations-01"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny resources not in allowed locations"

  policy_rule = jsonencode({
    if = {
      not = {
        field = "location"
        in    = var.pfmmgmt_allowed_locations
      }
    }
    then = {
      effect = "Deny"
    }
  })
}

resource "azurerm_subscription_policy_assignment" "pfmmgmt_allowed_locations" {
  name                 = "pas-prd-pfmmgmt-allowed-locations-01"
  display_name         = "PFMMGMT-1: Allow only particular locations for resources"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.pfmmgmt_allowed_locations.id

  non_compliance_message {
    content = <<-EOT
      Your resource needs to be deployed only in allowed locations: ${join(", ", var.pfmmgmt_allowed_locations)}.
      Please update your resource location and redeploy.
    EOT
  }
}

# Skipped for RG's to do not block automatic RG creation by Azure without tags
resource "azurerm_policy_definition" "pfmmgmt_allowed_environment_tag_values" {
  name         = "pde-prd-pfmmgmt-allowed-environment-tag-values-01"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit resources with invalid environment tag values"

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field     = "type"
          notEquals = "Microsoft.Resources/subscriptions/resourceGroups"
        },
        {
          field     = "type"
          notEquals = "Microsoft.Resources/subscriptions"
        },
        {
          anyOf = [
            {
              field  = "tags['environment']"
              exists = false
            },
            {
              field = "tags['environment']"
              notIn = local.environments
            }
          ]
        }
      ]
    }
    then = {
      effect = "Audit"
    }
  })
}

resource "azurerm_policy_definition" "pfmmgmt_audit_tag" {
  name         = "pde-prd-pfmmgmt-audit-tag-01"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit existence of a tag"

  policy_rule = jsonencode({
    if = {
      field  = "[concat('tags[', parameters('tagName'), ']')]"
      exists = false
    }
    then = {
      effect = "Audit"
    }
  })

  parameters = jsonencode({
    tagName = {
      type = "String"
      metadata = {
        displayName = "Tag Name"
        description = "Name of the tag, such as 'environment'"
      }
    }
  })
}

# Skipped for RG's to do not block automatic RG creation by Azure without tags
resource "azurerm_policy_set_definition" "pfmmgmt_required_tags" {
  name         = "psd-prd-pfmmgmt-required-tags-01"
  display_name = "Audit resources without custom tags with valid values"
  policy_type  = "Custom"

  lifecycle {
    replace_triggered_by = [
      azurerm_policy_definition.pfmmgmt_allowed_environment_tag_values.id,
      azurerm_policy_definition.pfmmgmt_audit_tag.id
    ]
  }

  # Validate environment values
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.pfmmgmt_allowed_environment_tag_values.id
  }

  # Require project_full_name tag
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.pfmmgmt_audit_tag.id
    parameter_values     = jsonencode({ tagName = { value = "project_full_name" } })
  }

  # Require project_id tag
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.pfmmgmt_audit_tag.id
    parameter_values     = jsonencode({ tagName = { value = "project_id" } })
  }

  # Require owner tag
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.pfmmgmt_audit_tag.id
    parameter_values     = jsonencode({ tagName = { value = "owner" } })
  }

  # Require cost_center tag
  policy_definition_reference {
    policy_definition_id = azurerm_policy_definition.pfmmgmt_audit_tag.id
    parameter_values     = jsonencode({ tagName = { value = "cost_center" } })
  }

}

resource "azurerm_subscription_policy_assignment" "pfmmgmt_required_tags" {
  name                 = "pas-prd-pfmmgmt-required-tags-on-resources-01"
  display_name         = "PFMMGMT-2: Audit tags on resources (environment, project_full_name, project_id, owner, cost_center) with valid values"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_set_definition.pfmmgmt_required_tags.id

  non_compliance_message {
    content                        = <<-EOT
      Your resource needs to have the required tag environment with value from range: ${join(", ", local.environments)}.
      Please update your resource with the required tag and value.
    EOT
    policy_definition_reference_id = azurerm_policy_set_definition.pfmmgmt_required_tags.policy_definition_reference[0].reference_id
  }

  non_compliance_message {
    content                        = <<-EOT
      Your resource needs to have the required tag project_full_name with value.
      Please update your resource with the required tag and value.
    EOT
    policy_definition_reference_id = azurerm_policy_set_definition.pfmmgmt_required_tags.policy_definition_reference[1].reference_id
  }

  non_compliance_message {
    content                        = <<-EOT
      Your resource needs to have the required tag project_id with value.
      Please update your resource with the required tag and value.
    EOT
    policy_definition_reference_id = azurerm_policy_set_definition.pfmmgmt_required_tags.policy_definition_reference[2].reference_id
  }

  non_compliance_message {
    content                        = <<-EOT
      Your resource needs to have the required tag owner with value.
      Please update your resource with the required tag and value.
    EOT
    policy_definition_reference_id = azurerm_policy_set_definition.pfmmgmt_required_tags.policy_definition_reference[3].reference_id
  }

  non_compliance_message {
    content                        = <<-EOT
      Your resource needs to have the required tag cost_center with value.
      Please update your resource with the required tag and value.
    EOT
    policy_definition_reference_id = azurerm_policy_set_definition.pfmmgmt_required_tags.policy_definition_reference[4].reference_id
  }
}

resource "azurerm_policy_definition" "pfmmgmt_secure_transfer_storage" {
  name         = "pde-prd-pfmmgmt-secure-transfer-storage-01"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Storage Accounts without secure transfer enabled"

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Storage/storageAccounts"
        },
        {
          field     = "Microsoft.Storage/storageAccounts/supportsHttpsTrafficOnly"
          notEquals = "true"
        }
      ]
    }
    then = {
      effect = "Audit"
    }
  })
}

resource "azurerm_subscription_policy_assignment" "pfmmgmt_secure_transfer_storage" {
  name                 = "pas-prd-pfmmgmt-secure-transfer-storage-01"
  display_name         = "PFMMGMT-3: Enforce secure transfer for Storage Accounts"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.pfmmgmt_secure_transfer_storage.id

  non_compliance_message {
    content = <<-EOT
      Your Storage Account needs to have secure transfer enabled.
      Please update your Storage Account configuration and redeploy.
    EOT
  }
}

resource "azurerm_policy_definition" "pfmmgmt_public_ip" {
  name         = "pde-prd-pfmmgmt-deny-public-ip-01"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny Public IP Addresses"

  policy_rule = jsonencode({
    if = {
      field  = "type"
      equals = "Microsoft.Network/publicIPAddresses"
    }
    then = {
      effect = "Deny"
    }
  })
}

resource "azurerm_subscription_policy_assignment" "pfmmgmt_public_ip" {
  name                 = "pas-prd-pfmmgmt-deny-public-ip-01"
  display_name         = "PFMMGMT-4: Deny Public IP Addresses usage"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.pfmmgmt_public_ip.id

  non_compliance_message {
    content = <<-EOT
      Public IP Addresses are not allowed to be used in this subscription.
      Please update your resource configuration to remove Public IP Address and redeploy.
      If you still need public IP address, request exclusion.
    EOT
  }

  not_scopes = concat(
    var.pfmmgmt_deny_public_ip_exclusions,
    [azurerm_resource_group.pfmmgmt_platform_networking_resource_group.id]
  )
}

resource "azurerm_policy_definition" "pfmmgmt_disks_type_and_size" {
  name         = "pde-prd-pfmmgmt-disks-type-and-size-01"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny managed disks not included in Standard_LRS SKU and/or larger than 64GB"

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Compute/disks"
        },
        {
          anyOf = [
            {
              field = "Microsoft.Compute/disks/sku.name"
              notIn = [
                "Standard_LRS"
              ]
            },
            {
              field   = "Microsoft.Compute/disks/diskSizeGB"
              greater = 64
            }
          ]
        }
      ]
    }
    then = {
      effect = "Deny"
    }
  })
}

resource "azurerm_subscription_policy_assignment" "pfmmgmt_disks_type_and_size" {
  name                 = "pas-prd-pfmmgmt-disks-type-and-size-01"
  display_name         = "PFMMGMT-5: Use only disks included in Standard_LRS SKU and/or smaller than 64GB"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.pfmmgmt_disks_type_and_size.id

  non_compliance_message {
    content = <<-EOT
      Your managed disk needs to be of type included in Standard_LRS SKU and/or smaller than 64GB.
      Please update your resource configuration to use allowed disk types and sizes and redeploy.
    EOT
  }
}

resource "azurerm_policy_definition" "pfmmgmt_non_free_aks" {
  name         = "pde-prd-pfmmgmt-deny-non-free-aks-01"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Deny Kubernetes clusters not in Free tier"

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.ContainerService/managedClusters"
        },
        {
          field     = "Microsoft.ContainerService/managedClusters/sku.tier"
          notEquals = "Free"
        }
      ]
    }
    then = {
      effect = "Deny"
    }
  })
}

resource "azurerm_subscription_policy_assignment" "pfmmgmt_non_free_aks" {
  name                 = "pas-prd-pfmmgmt-deny-non-free-aks-01"
  display_name         = "PFMMGMT-6: Deny Kubernetes clusters not in Free tier"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.pfmmgmt_non_free_aks.id

  non_compliance_message {
    content = <<-EOT
      Your Kubernetes cluster needs to be in Free tier.
      Please update your resource configuration to use Free tier and redeploy.
    EOT
  }
}

resource "azurerm_policy_definition" "pfmmgmt_subnets_nsg" {
  name         = "pde-prd-pfmmgmt-subnets-nsg-01"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit subnets without Network Security Group"

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Network/virtualNetworks/subnets"
        },
        {
          field  = "Microsoft.Network/virtualNetworks/subnets/networkSecurityGroup.id"
          exists = false
        }
      ]
    }
    then = {
      effect = "Audit"
    }
  })
}

resource "azurerm_subscription_policy_assignment" "pfmmgmt_subnets_nsg" {
  name                 = "pas-prd-pfmmgmt-subnets-nsg-01"
  display_name         = "PFMMGMT-7: Subnets should have a Network Security Group"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.pfmmgmt_subnets_nsg.id

  non_compliance_message {
    content = <<-EOT
      Your subnet needs to have a Network Security Group associated.
      Please associate an NSG to the subnet and redeploy.
    EOT
  }
}

resource "azurerm_policy_definition" "pfmmgmt_vms_cmek" {
  name         = "pde-prd-pfmmgmt-vms-cmek-01"
  policy_type  = "Custom"
  mode         = "All"
  display_name = "Audit Virtual Machines without Customer Managed Encryption Keys"

  policy_rule = jsonencode({
    if = {
      allOf = [
        {
          field  = "type"
          equals = "Microsoft.Compute/virtualMachines"
        },
        {
          field  = "Microsoft.Compute/virtualMachines/storageProfile.osDisk.managedDisk.diskEncryptionSet.id"
          exists = false
        }
      ]
    }
    then = {
      effect = "Audit"
    }
  })
}

resource "azurerm_subscription_policy_assignment" "pfmmgmt_vms_cmek" {
  name                 = "pas-prd-pfmmgmt-vms-cmek-01"
  display_name         = "PFMMGMT-8: Virtual machines should use customer-managed encryption keys"
  subscription_id      = data.azurerm_subscription.current.id
  policy_definition_id = azurerm_policy_definition.pfmmgmt_vms_cmek.id

  non_compliance_message {
    content = <<-EOT
      Your Virtual Machine needs to have customer-managed encryption keys enabled for its disks.
      Please update your Virtual Machine configuration and redeploy.
    EOT
  }
}

# TODO: key needs to be valid for particular env (lab key = lab disk)
