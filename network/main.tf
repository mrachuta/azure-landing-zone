resource "azurerm_resource_group" "hub_resource_group" {
  name     = var.hub_resource_group_name
  location = var.hub_resource_group_location
}

resource "azurerm_virtual_network" "hub_network" {
  name                = var.hub_network_name
  location            = azurerm_resource_group.hub_resource_group.location
  resource_group_name = azurerm_resource_group.hub_resource_group.name
  address_space       = var.hub_network_address_space
}

resource "azurerm_subnet" "hub_network_subnet_gateway" {
  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub_resource_group.name
  virtual_network_name = azurerm_virtual_network.hub_network.name
  address_prefixes     = var.hub_network_subnet_gateway_address_prefixes
}

resource "azurerm_subnet" "hub_network_subnet_backup" {
  name                 = var.hub_network_subnet_backup_name
  resource_group_name  = azurerm_resource_group.hub_resource_group.name
  virtual_network_name = azurerm_virtual_network.hub_network.name
  address_prefixes     = var.hub_network_subnet_backup_address_prefixes
}

resource "azurerm_public_ip" "hub_virtual_network_gateway_public_ip" {
  name                = var.hub_virtual_network_gateway_public_ip_name
  location            = azurerm_resource_group.hub_resource_group.location
  resource_group_name = azurerm_resource_group.hub_resource_group.name
  allocation_method = "Static"
}

resource "azurerm_virtual_network_gateway" "hub_virtual_network_gateway" {
  name                = var.hub_virtual_network_gateway_name
  location            = azurerm_resource_group.hub_resource_group.location
  resource_group_name = azurerm_resource_group.hub_resource_group.name

  type     = "Vpn"
  vpn_type = "RouteBased"

  active_active = false
  enable_bgp    = false
  sku           = "VpnGw1"

  ip_configuration {
    name                          = "${var.hub_virtual_network_gateway_name}-cfg-01"
    public_ip_address_id          = azurerm_public_ip.hub_virtual_network_gateway_public_ip.id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = azurerm_subnet.hub_network_subnet_gateway.id
  }

  timeouts {
    create = "60m"
  }

}

resource "azurerm_local_network_gateway" "hub_local_network_gateway_onprem" {
  name                = var.hub_local_network_gateway_onprem_name
  location            = azurerm_resource_group.hub_resource_group.location
  resource_group_name = azurerm_resource_group.hub_resource_group.name
  gateway_address     = var.hub_local_network_gateway_onprem_address
  address_space       = var.hub_local_network_gateway_onprem_address_space
}

resource "azurerm_virtual_network_gateway_connection" "hub_virtual_network_gateway_connection_onprem" {
  name                = var.hub_virtual_network_gateway_connection_onprem_name
  location            = azurerm_resource_group.hub_resource_group.location
  resource_group_name = azurerm_resource_group.hub_resource_group.name

  type                       = "IPsec"
  virtual_network_gateway_id = azurerm_virtual_network_gateway.hub_virtual_network_gateway.id
  local_network_gateway_id   = azurerm_local_network_gateway.hub_local_network_gateway_onprem.id

  shared_key = var.hub_virtual_network_gateway_connection_onprem_key
}

resource "azurerm_virtual_network" "project_network" {
  for_each = var.projects_network_configuration
  name                = each.value.virtual_network_name
  resource_group_name = data.azurerm_resource_group.project_resource_group[each.key].name
  location = data.azurerm_resource_group.project_resource_group[each.key].location
  address_space       = each.value.virtual_network_address_space
}

resource "azurerm_subnet" "project_network_subnet" {
  for_each = { for combined in flatten([
    for project_key, project in var.projects_network_configuration : [
      for subnet_key, subnet in project.virtual_network_subnets : {
        project_key = project_key
        subnet_key  = subnet_key
        subnet      = subnet
      }
    ]
  ]) : "${combined.project_key}_${combined.subnet_key}" => combined }
  name                  = each.value.subnet.subnet_name
  resource_group_name  = azurerm_virtual_network.project_network[each.value.project_key].resource_group_name
  virtual_network_name = azurerm_virtual_network.project_network[each.value.project_key].name
  address_prefixes     = each.value.subnet.subnet_address_prefixes
}

resource "azurerm_virtual_network_peering" "project_network_peering_from_hub" {
  for_each = { for project_key, project in var.projects_network_configuration : project_key => project if project.create_peering == true}
  name                      = "vnp-${var.hub_network_name}-to-${each.value.virtual_network_name}"
  resource_group_name       = azurerm_resource_group.hub_resource_group.name
  virtual_network_name      = azurerm_virtual_network.hub_network.name
  remote_virtual_network_id = azurerm_virtual_network.project_network[each.key].id
  allow_forwarded_traffic = false
  allow_gateway_transit = true
  allow_virtual_network_access = false
  use_remote_gateways = false
}

resource "azurerm_virtual_network_peering" "project_network_peering_to_hub" {
  for_each = { for project_key, project in var.projects_network_configuration : project_key => project if project.create_peering == true}
  name                      = "vnp-${each.value.virtual_network_name}-to-${var.hub_network_name}"
  resource_group_name       = data.azurerm_resource_group.project_resource_group[each.key].name
  virtual_network_name      = azurerm_virtual_network.project_network[each.key].name
  remote_virtual_network_id = azurerm_virtual_network.hub_network.id
  allow_forwarded_traffic = false
  allow_gateway_transit = false
  allow_virtual_network_access = false
  use_remote_gateways = true
}
