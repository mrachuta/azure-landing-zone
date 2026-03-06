
# Azure AD Groups

resource "azuread_group" "pfmident_groups" {
  for_each         = { for g in var.pfmident_groups : g.name => g }
  display_name     = lookup(each.value, "name", null)
  description      = lookup(each.value, "description", null)
  security_enabled = lookup(each.value, "security_enabled", true)
}

#
# Group Memberships
#
# resource "azuread_group_member" "pfident_platform_management_admins" {
#   for_each         = { for email, user in data.azuread_user.pfident_platform_management_admin : email => user.object_id }
#   group_object_id  = azuread_group.pfident_platform_management_admins.object_id
#   member_object_id = each.value
# }

# resource "azuread_group_member" "pfident_platform_identity_admins" {
#   for_each         = { for email, user in data.azuread_user.pfident_platform_identity_admin : email => user.object_id }
#   group_object_id  = azuread_group.pfident_platform_identity_admins.object_id
#   member_object_id = each.value
# }

# resource "azuread_group_member" "pfident_platform_security_admins" {
#   for_each         = { for email, user in data.azuread_user.pfident_platform_security_admin : email => user.object_id }
#   group_object_id  = azuread_group.pfident_platform_security_admins.object_id
#   member_object_id = each.value
# }

# resource "azuread_group_member" "pfident_platform_networking_admins" {
#   for_each         = { for email, user in data.azuread_user.pfident_platform_networking_admin : email => user.object_id }
#   group_object_id  = azuread_group.pfident_platform_networking_admins.object_id
#   member_object_id = each.value
# }

#
# Role Assignments
#
resource "azurerm_role_assignment" "pfmident_contributor_to_pfmident_platform_management_team_general" {
  for_each             = { for m in var.pfmident_platform_management_team_members : "${m.type}:${m.name}" => m }
  scope                = data.azurerm_resource_group.pfmident_platform_management_resource_group.id
  role_definition_name = "Contributor"
  principal_id         = local.principal_id[each.key]
  depends_on           = [azuread_group.pfmident_groups]
}

resource "azurerm_role_assignment" "pfmident_contributor_to_pfmident_platform_identity_team_general" {
  for_each             = { for m in var.pfmident_platform_identity_team_members : "${m.type}:${m.name}" => m }
  scope                = data.azurerm_resource_group.pfmident_platform_identity_resource_group.id
  role_definition_name = "Contributor"
  principal_id         = local.principal_id[each.key]
  depends_on           = [azuread_group.pfmident_groups]
}

resource "azurerm_role_assignment" "pfmident_contributor_to_pfmident_platform_security_team_general" {
  for_each             = { for m in var.pfmident_platform_security_team_members : "${m.type}:${m.name}" => m }
  scope                = data.azurerm_resource_group.pfmident_platform_security_resource_group.id
  role_definition_name = "Contributorr"
  principal_id         = local.principal_id[each.key]
  depends_on           = [azuread_group.pfmident_groups]
}

resource "azurerm_role_assignment" "pfmident_contributor_to_pfmident_platform_networking_team_general" {
  for_each             = { for m in var.pfmident_platform_networking_team_members : "${m.type}:${m.name}" => m }
  scope                = data.azurerm_resource_group.pfmident_platform_networking_resource_group.id
  role_definition_name = "Contributor"
  principal_id         = local.principal_id[each.key]
  depends_on           = [azuread_group.pfmident_groups]
}

# Custom scoped permissions
resource "azurerm_role_assignment" "pfmident_custom_permissions" {
  for_each = { for m in var.pfmident_platform_custom_permissions :
    "${m.type}:${m.name}:${m.scope}" => m
  }
  scope                = each.value.scope
  role_definition_name = each.value.role_definition_name
  principal_id         = local.custom_permission_principal_id[each.key]
  depends_on           = [azuread_group.pfmident_groups]
}

