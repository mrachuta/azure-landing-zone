
resource "azurerm_consumption_budget_subscription" "pfmmgmt_budget" {
  name            = var.pfmmgmt_budget_name
  subscription_id = data.azurerm_subscription.current.id

  amount     = var.pfmmgmt_budget_monthly_amount
  time_grain = "Monthly"

  time_period {
    start_date = var.pfmmgmt_budget_start_date
    end_date   = var.pfmmgmt_budget_end_date
  }

  notification {
    enabled   = true
    threshold = 50.0
    operator  = "EqualTo"

    contact_emails = var.pfmmgmt_budget_notification_contact_emails

    contact_roles = [
      "Owner",
    ]
  }

  notification {
    enabled        = false
    threshold      = 90.0
    operator       = "GreaterThan"
    threshold_type = "Forecasted"

    contact_emails = var.pfmmgmt_budget_notification_contact_emails
  }
}

resource "azurerm_resource_group" "pfmmgmt_platform_management_resource_group" {
  name     = var.pfmmgmt_platform_management_resource_group_name
  location = var.pfmmgmt_platform_location
  tags     = var.pfmmgmt_platform_management_resource_group_tags
}

resource "azurerm_resource_group" "pfmmgmt_platform_identity_resource_group" {
  name     = var.pfmmgmt_platform_identity_resource_group_name
  location = var.pfmmgmt_platform_location
  tags     = var.pfmmgmt_platform_identity_resource_group_tags
}

resource "azurerm_resource_group" "pfmmgmt_platform_security_resource_group" {
  name     = var.pfmmgmt_platform_security_resource_group_name
  location = var.pfmmgmt_platform_location
  tags     = var.pfmmgmt_platform_security_resource_group_tags
}

resource "azurerm_resource_group" "pfmmgmt_platform_networking_resource_group" {
  name     = var.pfmmgmt_platform_networking_resource_group_name
  location = var.pfmmgmt_platform_location
  tags     = var.pfmmgmt_platform_networking_resource_group_tags
}

resource "azurerm_resource_group" "pfmmgmt_project_resource_group" {
  for_each = { for p in var.pfmmgmt_projects_resource_groups : p.project_id => p }

  name     = lookup(each.value, "resource_group_name", null)
  location = lookup(each.value, "resource_group_location", null)
  tags     = lookup(each.value, "resource_group_tags", null)
}
