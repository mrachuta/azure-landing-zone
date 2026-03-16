resource "azurerm_network_interface" "vm" {
  name                  = var.vm_name
  location              = var.vm_location
  resource_group_name   = var.resource_group_name
  tags                  = var.tags

  ip_configuration {
    name                          = "${var.vm_name}-ipcfg-01"
    subnet_id                     = var.vm_subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.vm_location
  resource_group_name   = var.resource_group_name
  size                  = "Standard_B2ats_v2"
  admin_username        = var.vm_ssh_username
  network_interface_ids = [azurerm_network_interface.vm.id]
  tags                  = var.tags

  admin_ssh_key {
    username   = var.vm_ssh_username
    public_key = file(var.vm_ssh_key_path)
  }

  os_disk {
    caching                = "ReadWrite"
    storage_account_type   = "Standard_LRS"
    disk_size_gb           = "32"
    disk_encryption_set_id = var.vm_disk_encryption_set_id
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
