
resource "azurerm_virtual_network" "pfmnet_hub_network" {
  name                = var.pfmnet_hub_network_name
  location            = data.azurerm_resource_group.pfmnet_resource_group_name.location
  resource_group_name = data.azurerm_resource_group.pfmnet_resource_group_name.name
  tags                = merge(var.pfmnet_hub_objects_common_tags, var.pfmnet_hub_network_tags)
  address_space       = var.pfmnet_hub_network_address_space
}

# TODO: parametrize on/off
# resource "azurerm_public_ip" "pfmnet_hub_nat_gateway_public_ip" {
#   name                = var.pfmnet_hub_nat_gateway_public_ip_name
#   location            = data.azurerm_resource_group.pfmnet_resource_group_name.location
#   resource_group_name = data.azurerm_resource_group.pfmnet_resource_group_name.name
#   tags                = merge(var.pfmnet_hub_objects_common_tags, var.pfmnet_hub_nat_gateway_public_ip_tags)
#   allocation_method   = "Static"
# }

# resource "azurerm_nat_gateway" "pfmnet_hub_nat_gateway" {
#   name                = var.pfmnet_hub_nat_gateway_name
#   location            = data.azurerm_resource_group.pfmnet_resource_group_name.location
#   resource_group_name = data.azurerm_resource_group.pfmnet_resource_group_name.name
#   tags                = merge(var.pfmnet_hub_objects_common_tags, var.pfmnet_hub_nat_gateway_tags)
#   sku_name            = "Standard"
# }

# resource "azurerm_nat_gateway_public_ip_association" "pfmnet_hub_nat_gateway_public_ip_association" {
#   nat_gateway_id       = azurerm_nat_gateway.pfmnet_hub_nat_gateway.id
#   public_ip_address_id = azurerm_public_ip.pfmnet_hub_nat_gateway_public_ip.id
# }

resource "azurerm_subnet" "pfmnet_hub_network_subnet_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = data.azurerm_resource_group.pfmnet_resource_group_name.name
  virtual_network_name = azurerm_virtual_network.pfmnet_hub_network.name
  address_prefixes     = var.pfmnet_hub_network_subnet_gateway_address_prefixes
}

resource "azurerm_subnet" "pfmnet_hub_network_subnet_nat" {
  name                            = var.pfmnet_hub_network_subnet_nat_name
  resource_group_name             = data.azurerm_resource_group.pfmnet_resource_group_name.name
  virtual_network_name            = azurerm_virtual_network.pfmnet_hub_network.name
  address_prefixes                = var.pfmnet_hub_network_subnet_nat_address_prefixes
  default_outbound_access_enabled = var.pfmnet_hub_network_subnet_nat_default_outbound_access_enabled
}

# resource "azurerm_subnet_nat_gateway_association" "pfmnet_hub_network_subnet_nat_nat_gateway_association" {
#   subnet_id      = azurerm_subnet.pfmnet_hub_network_subnet_nat.id
#   nat_gateway_id = azurerm_nat_gateway.pfmnet_hub_nat_gateway.id
# }


resource "azurerm_network_security_group" "pfmnet_hub_network_subnet_nat_network_security_group" {
  name                = var.pfmnet_hub_network_subnet_nat_network_security_group_name
  location            = data.azurerm_resource_group.pfmnet_resource_group_name.location
  resource_group_name = data.azurerm_resource_group.pfmnet_resource_group_name.name
  tags                = merge(var.pfmnet_hub_objects_common_tags, var.pfmnet_hub_network_subnet_nat_network_security_group_tags)

  dynamic "security_rule" {
    for_each = var.pfmnet_hub_network_subnet_nat_network_security_group_rules
    content {
      name                       = lookup(security_rule.value, "name", null)
      priority                   = lookup(security_rule.value, "priority", null)
      direction                  = lookup(security_rule.value, "direction", null)
      access                     = lookup(security_rule.value, "access", null)
      protocol                   = lookup(security_rule.value, "protocol", null)
      source_port_range          = lookup(security_rule.value, "source_port_range", null)
      destination_port_range     = lookup(security_rule.value, "destination_port_range", null)
      source_address_prefix      = lookup(security_rule.value, "source_address_prefix", null)
      destination_address_prefix = lookup(security_rule.value, "destination_address_prefix", null)
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "pfmnet_hub_network_subnet_nat_network_security_group_association" {
  subnet_id                 = azurerm_subnet.pfmnet_hub_network_subnet_nat.id
  network_security_group_id = azurerm_network_security_group.pfmnet_hub_network_subnet_nat_network_security_group.id
}

# TODO: parametrize on/off
resource "azurerm_route_table" "pfmnet_hub_nat_vm_route_table" {
  name                = var.pfmnet_hub_nat_vm_route_table_name
  location            = data.azurerm_resource_group.pfmnet_resource_group_name.location
  resource_group_name = data.azurerm_resource_group.pfmnet_resource_group_name.name
}

# TODO: parametrize on/off
resource "azurerm_route" "pfmnet_hub_nat_route_via_nat_vm" {
  name                   = var.pfmnet_hub_nat_route_via_nat_vm_name
  resource_group_name    = data.azurerm_resource_group.pfmnet_resource_group_name.name
  route_table_name       = azurerm_route_table.pfmnet_hub_nat_vm_route_table.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = azurerm_network_interface.pfmnet_hub_nat_vm.private_ip_address
}

resource "azurerm_network_watcher" "pfmnet_network_watcher" {
  name                = var.pfmnet_network_watcher_name
  location            = data.azurerm_resource_group.pfmnet_resource_group_name.location
  resource_group_name = data.azurerm_resource_group.pfmnet_resource_group_name.name
  tags                = merge(var.pfmnet_hub_objects_common_tags, var.pfmnet_network_watcher_tags)
}

resource "azurerm_public_ip" "pfmnet_hub_virtual_network_gateway_public_ip" {
  name                = var.pfmnet_hub_virtual_network_gateway_public_ip_name
  location            = data.azurerm_resource_group.pfmnet_resource_group_name.location
  resource_group_name = data.azurerm_resource_group.pfmnet_resource_group_name.name
  tags                = merge(var.pfmnet_hub_objects_common_tags, var.pfmnet_hub_virtual_network_gateway_public_ip_tags)
  allocation_method   = "Static"
}

resource "azurerm_virtual_network_gateway" "pfmnet_hub_virtual_network_gateway" {
  name                = var.pfmnet_hub_virtual_network_gateway_name
  location            = data.azurerm_resource_group.pfmnet_resource_group_name.location
  resource_group_name = data.azurerm_resource_group.pfmnet_resource_group_name.name
  tags                = merge(var.pfmnet_hub_objects_common_tags, var.pfmnet_hub_virtual_network_gateway_tags)


  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "${var.pfmnet_hub_virtual_network_gateway_name}-ipcfg-01"
    public_ip_address_id          = azurerm_public_ip.pfmnet_hub_virtual_network_gateway_public_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.pfmnet_hub_network_subnet_gateway.id
  }

  timeouts {
    create = "60m"
    delete = "60m"
    update = "60m"
  }

}

resource "azurerm_local_network_gateway" "pfmnet_hub_local_network_gateway_onprem" {
  name                = var.pfmnet_hub_local_network_gateway_onprem_name
  location            = data.azurerm_resource_group.pfmnet_resource_group_name.location
  resource_group_name = data.azurerm_resource_group.pfmnet_resource_group_name.name
  tags                = merge(var.pfmnet_hub_objects_common_tags, var.pfmnet_hub_local_network_gateway_onprem_tags)
  gateway_address     = var.pfmnet_hub_local_network_gateway_onprem_address
  address_space       = var.pfmnet_hub_local_network_gateway_onprem_address_space

}

resource "azurerm_virtual_network_gateway_connection" "pfmnet_hub_virtual_network_gateway_connection_onprem" {
  name                = var.pfmnet_hub_virtual_network_gateway_connection_onprem_name
  location            = data.azurerm_resource_group.pfmnet_resource_group_name.location
  resource_group_name = data.azurerm_resource_group.pfmnet_resource_group_name.name
  tags                = merge(var.pfmnet_hub_objects_common_tags, var.pfmnet_hub_virtual_network_gateway_connection_onprem_tags)

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.pfmnet_hub_virtual_network_gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.pfmnet_hub_local_network_gateway_onprem.id

  shared_key = var.pfmnet_hub_virtual_network_gateway_connection_onprem_key
}

resource "azurerm_virtual_network" "pfmnet_project_network" {
  for_each            = { for p in var.pfmnet_projects_network_configuration : p.project_id => p }
  name                = lookup(each.value, "virtual_network_name", null)
  resource_group_name = data.azurerm_resource_group.pfmnet_projects_network_configuration[each.key].name
  location            = data.azurerm_resource_group.pfmnet_projects_network_configuration[each.key].location
  tags                = lookup(each.value, "virtual_network_tags", null)
  address_space       = lookup(each.value, "virtual_network_address_space", null)

}

resource "azurerm_subnet" "pfmnet_project_network_subnet" {
  for_each = { for combined in flatten([
    for p in var.pfmnet_projects_network_configuration : [
      for s in p.virtual_network_subnets : {
        project_id                             = p.project_id
        subnet_name                            = s.subnet_name
        subnet_address_prefixes                = s.subnet_address_prefixes
        subnet_default_outbound_access_enabled = s.subnet_default_outbound_access_enabled
      }
    ]
  ]) : "${combined.project_id}_${combined.subnet_name}" => combined }
  name                            = lookup(each.value, "subnet_name", null)
  resource_group_name             = azurerm_virtual_network.pfmnet_project_network[each.value.project_id].resource_group_name
  virtual_network_name            = azurerm_virtual_network.pfmnet_project_network[each.value.project_id].name
  address_prefixes                = lookup(each.value, "subnet_address_prefixes")
  default_outbound_access_enabled = lookup(each.value, "subnet_default_outbound_access_enabled")

  # Ignore changes implemented by end user
  lifecycle {
    ignore_changes = [delegation]
  }
}

resource "azurerm_subnet_route_table_association" "pfmnet_project_network_subnet_nat_vm_route_table" {
  for_each = { for combined in flatten([
    for p in var.pfmnet_projects_network_configuration : [
      for s in p.virtual_network_subnets : {
        project_id  = p.project_id
        subnet_name = s.subnet_name
        subnet_route_via_nat_vm = s.subnet_route_via_nat_vm
      }
    ]
  ]) : "${combined.project_id}_${combined.subnet_name}" => combined if combined.subnet_route_via_nat_vm == true }
  subnet_id      = azurerm_subnet.pfmnet_project_network_subnet[each.key].id
  route_table_id = azurerm_route_table.pfmnet_hub_nat_vm_route_table.id
}

# TODO: parametrize on/off
# resource "azurerm_subnet_nat_gateway_association" "pfmnet_project_network_subnet_nat_gateway_association" {
#   for_each = { for combined in flatten([
#     for p in var.pfmnet_projects_network_configuration : [
#       for s in p.virtual_network_subnets : {
#         project_id                     = p.project_id
#         subnet_name                    = s.subnet_name
#         subnet_nat_gateway_association = s.subnet_nat_gateway_association
#       }
#     ]
#   ]) : "${combined.project_id}_${combined.subnet_name}" => combined if combined.subnet_nat_gateway_association == true }

#   subnet_id      = azurerm_subnet.pfmnet_project_network_subnet[each.key].id
#   nat_gateway_id = azurerm_nat_gateway.pfmnet_hub_nat_gateway.id
# }

resource "azurerm_network_security_group" "pfmnet_project_network_subnet_network_security_group" {
  for_each = { for combined in flatten([
    for p in var.pfmnet_projects_network_configuration : [
      for s in p.virtual_network_subnets : {
        project_id                          = p.project_id
        subnet_name                         = s.subnet_name
        subnet_network_security_group_name  = s.subnet_network_security_group_name
        subnet_network_security_group_tags  = s.subnet_network_security_group_tags
        subnet_network_security_group_rules = s.subnet_network_security_group_rules
      }
    ]
  ]) : "${combined.project_id}_${combined.subnet_name}" => combined }
  name                = lookup(each.value, "subnet_network_security_group_name", null)
  location            = azurerm_virtual_network.pfmnet_project_network[each.value.project_id].location
  resource_group_name = azurerm_virtual_network.pfmnet_project_network[each.value.project_id].resource_group_name
  tags                = merge(var.pfmnet_hub_objects_common_tags, each.value.subnet_network_security_group_tags)

  dynamic "security_rule" {
    for_each = each.value.subnet_network_security_group_rules
    content {
      name                       = lookup(security_rule.value, "name", null)
      priority                   = lookup(security_rule.value, "priority", null)
      direction                  = lookup(security_rule.value, "direction", null)
      access                     = lookup(security_rule.value, "access", null)
      protocol                   = lookup(security_rule.value, "protocol", null)
      source_port_range          = lookup(security_rule.value, "source_port_range", null)
      destination_port_range     = lookup(security_rule.value, "destination_port_range", null)
      source_address_prefix      = lookup(security_rule.value, "source_address_prefix", null)
      destination_address_prefix = lookup(security_rule.value, "destination_address_prefix", null)
    }
  }
}

resource "azurerm_subnet_network_security_group_association" "pfmnet_project_network_subnet_network_security_group_association" {
  for_each = { for combined in flatten([
    for p in var.pfmnet_projects_network_configuration : [
      for s in p.virtual_network_subnets : {
        project_id  = p.project_id
        subnet_name = s.subnet_name
      }
    ]
  ]) : "${combined.project_id}_${combined.subnet_name}" => combined }

  subnet_id                 = azurerm_subnet.pfmnet_project_network_subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.pfmnet_project_network_subnet_network_security_group[each.key].id
}

resource "azurerm_virtual_network_peering" "pfmnet_project_network_peering_from_hub" {
  for_each                     = { for p in var.pfmnet_projects_network_configuration : p.project_id => p if p.create_peering == true }
  name                         = "vnp-${var.pfmnet_hub_network_name}-to-${lookup(each.value, "virtual_network_name", null)}"
  resource_group_name          = data.azurerm_resource_group.pfmnet_resource_group_name.name
  virtual_network_name         = azurerm_virtual_network.pfmnet_hub_network.name
  remote_virtual_network_id    = azurerm_virtual_network.pfmnet_project_network[each.key].id
  # required by nat_vm
  allow_forwarded_traffic      = true
  allow_gateway_transit        = true
  allow_virtual_network_access = false
  use_remote_gateways          = false
}

resource "azurerm_virtual_network_peering" "pfmnet_project_network_peering_to_hub" {
  for_each                     = { for p in var.pfmnet_projects_network_configuration : p.project_id => p if p.create_peering == true }
  name                         = "vnp-${lookup(each.value, "virtual_network_name", null)}-to-${var.pfmnet_hub_network_name}"
  resource_group_name          = data.azurerm_resource_group.pfmnet_projects_network_configuration[each.key].name
  virtual_network_name         = azurerm_virtual_network.pfmnet_project_network[each.key].name
  remote_virtual_network_id    = azurerm_virtual_network.pfmnet_hub_network.id
  # required by nat_vm
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  allow_virtual_network_access = false
  use_remote_gateways          = true

  depends_on = [azurerm_virtual_network_peering.pfmnet_project_network_peering_from_hub]
}
