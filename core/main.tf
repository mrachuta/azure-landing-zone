
resource "azurerm_consumption_budget_subscription" "subscription_budget" {
  name            = var.subscription_budget_name
  subscription_id = data.azurerm_subscription.current.id

  amount     = 30
  time_grain = "Monthly"

  time_period {
    start_date = var.subscription_budget_start_date
    end_date   = var.subscription_budget_end_date
  }

  notification {
    enabled   = true
    threshold = 50.0
    operator  = "EqualTo"

    contact_emails = var.subscription_budget_notification_contact_emails

    contact_roles = [
      "Owner",
    ]
  }

  notification {
    enabled        = false
    threshold      = 90.0
    operator       = "GreaterThan"
    threshold_type = "Forecasted"

    contact_emails = var.subscription_budget_notification_contact_emails
  }
}

#TODO: policies for org


resource "azurerm_resource_group" "project_resource_group" {
  for_each = var.projects_resource_groups

  name     = each.value.resource_group_name
  location = each.value.resource_group_location
  tags     = each.value.resource_group_tags
}
