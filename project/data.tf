data "azurerm_subnet" "vngtest_subnet" {
  name                 = var.vngtest_subnet_name
  virtual_network_name = var.project_network_name
  resource_group_name  = var.project_resource_group_name
}
