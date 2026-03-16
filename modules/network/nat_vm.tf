resource "azurerm_network_interface" "pfmnet_hub_nat_vm" {
  name                  = var.pfmnet_hub_nat_vm_name
  location              = data.azurerm_resource_group.pfmnet_resource_group_name.location
  resource_group_name   = data.azurerm_resource_group.pfmnet_resource_group_name.name
  ip_forwarding_enabled = true
  tags                  = merge(var.pfmnet_hub_objects_common_tags, var.pfmnet_hub_nat_vm_tags)

  ip_configuration {
    name                          = "${var.pfmnet_hub_nat_vm_name}-ipcfg-01"
    subnet_id                     = azurerm_subnet.pfmnet_hub_network_subnet_nat.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.pfmnet_hub_nat_vm_private_ip_address
  }
}

#TODO: startup script to enable ip_forwarding (test it first) and add iptables rule
resource "azurerm_linux_virtual_machine" "pfmnet_hub_nat_vm" {
  name                  = var.pfmnet_hub_nat_vm_name
  location              = data.azurerm_resource_group.pfmnet_resource_group_name.location
  resource_group_name   = data.azurerm_resource_group.pfmnet_resource_group_name.name
  size                  = "Standard_B2ats_v2"
  admin_username        = var.pfmnet_nat_vm_ssh_username
  network_interface_ids = [azurerm_network_interface.pfmnet_hub_nat_vm.id]
  tags                  = merge(var.pfmnet_hub_objects_common_tags, var.pfmnet_hub_nat_vm_tags)


  admin_ssh_key {
    username   = var.pfmnet_nat_vm_ssh_username
    public_key = file(var.pfmnet_nat_vm_ssh_key_path)
  }

  os_disk {
    caching                = "ReadWrite"
    storage_account_type   = "Standard_LRS"
    disk_size_gb           = "32"
    disk_encryption_set_id = var.pfmnet_nat_vm_disk_encryption_set_id
  }

  source_image_reference {
    # publisher = lookup(var.vngtest_vm_image_details, "publisher", "Canonical")
    # offer     = lookup(var.vngtest_vm_image_details, "offer", "22_04-lts-gen2")
    # sku       = lookup(var.vngtest_vm_image_details, "sku", "server")
    # version   = lookup(var.vngtest_vm_image_details, "version", "latest")
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
