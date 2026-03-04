resource "azurerm_network_interface" "vngtest_network_interface" {
  name                = var.vngtest_network_interface_name
  location            = var.project_resource_group_location
  resource_group_name = var.project_resource_group_name

  ip_configuration {
    name                          = "${var.vngtest_network_interface_name}-ipcfg-01"
    subnet_id                     = data.azurerm_subnet.vngtest_subnet.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vngtest_vm" {
  name                  = var.vngtest_vm_name
  location              = var.project_resource_group_location
  resource_group_name   = var.project_resource_group_name
  size                  = "Standard_B2ats_v2"
  admin_username        = "azadm"
  network_interface_ids = [azurerm_network_interface.vngtest_network_interface.id]

  admin_ssh_key {
    username   = "azadm"
    public_key = file(var.vngtest_vm_ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = lookup(var.vngtest_vm_image_details, "publisher", "Canonical")
    offer     = lookup(var.vngtest_vm_image_details, "offer", "22_04-lts-gen2")
    sku       = lookup(var.vngtest_vm_image_details, "sku", "server")
    version   = lookup(var.vngtest_vm_image_details, "version", "latest")
  }
}
