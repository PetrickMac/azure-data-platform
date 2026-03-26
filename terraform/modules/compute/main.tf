resource "azurerm_network_interface" "web_vm" {
  name                = "nic-vm-web-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.web_subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "web" {
  name                            = "vm-web-${var.environment}"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  size                            = "Standard_B1s"
  admin_username                  = "azureuser"
  network_interface_ids           = [azurerm_network_interface.web_vm.id]
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = var.ssh_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  tags = var.tags
}
