resource "azurerm_public_ip" "bastion" {
  name                = "pip-bastion-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "main" {
  name                = "bas-hub-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Basic"

  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = azurerm_subnet.hub_bastion.id
    public_ip_address_id = azurerm_public_ip.bastion.id
  }

  tags = var.tags
}
