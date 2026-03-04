locals {
  # combine all principals once
  raw_principals = concat(
    var.pfmident_platform_management_team_members,
    var.pfmident_platform_identity_team_members,
    var.pfmident_platform_security_team_members,
    var.pfmident_platform_networking_team_members,
    var.pfmident_platform_custom_permissions
  )

  # compute unique map keyed by principal identifier
  principals_by_key = {
    for p in local.raw_principals :
    (p.type == "user_assigned_managed_identity" ?
      "user_assigned_managed_identity:${p.identity_resource_group}:${p.name}" :
    "${p.type}:${p.name}") => p
  }

  # map composite custom permission entries directly to principal_id
  custom_permission_principal_id = {
    for c in var.pfmident_platform_custom_permissions :
    "${c.type}:${c.name}:${c.scope}" =>
    lookup(
      local.principal_id,
      (c.type == "user_assigned_managed_identity" ?
        "user_assigned_managed_identity:${c.identity_resource_group}:${c.name}" :
      "${c.type}:${c.name}"),
      null
    )
  }

  users                            = { for k, v in local.principals_by_key : k => v if v.type == "user" }
  groups                           = { for k, v in local.principals_by_key : k => v if v.type == "group" }
  service_principals               = { for k, v in local.principals_by_key : k => v if v.type == "service_principal" }
  user_assigned_managed_identities = { for k, v in local.principals_by_key : k => v if v.type == "user_assigned_managed_identity" }

  principal_id = {
    for k, v in local.principals_by_key : k => (
      v.type == "user" ? data.azuread_user.pfmident_user[k].object_id :
      v.type == "group" ? data.azuread_group.pfmident_group[k].object_id :
      v.type == "service_principal" ? data.azuread_service_principal.pfmident_service_principal[k].object_id :
      v.type == "user_assigned_managed_identity" ? data.azurerm_user_assigned_identity.pfmident_user_assigned_managed_identity[k].principal_id :
      null
    )
  }
}
