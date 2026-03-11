# Resource Group
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.project_name}-${var.environment}"
  location = var.location

  tags = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }
}

# Networking Module
module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  hub_vnet_cidr       = var.hub_vnet_cidr
  spoke_vnet_cidr     = var.spoke_vnet_cidr

  tags = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }
}