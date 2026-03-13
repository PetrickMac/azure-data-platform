
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

# Security Module
module "security" {
  source = "./modules/security"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment

  web_subnet_id   = module.networking.spoke_web_subnet_id
  app_subnet_id   = module.networking.spoke_app_subnet_id
  data_subnet_id  = module.networking.spoke_data_subnet_id

  web_subnet_cidr = cidrsubnet(var.spoke_vnet_cidr, 8, 0)
  app_subnet_cidr = cidrsubnet(var.spoke_vnet_cidr, 8, 1)

  tags = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }
}