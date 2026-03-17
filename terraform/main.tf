
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
  project_name        = var.project_name

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

# Storage Module
module "storage" {
  source = "./modules/storage"

  resource_group_name           = azurerm_resource_group.main.name
  location                      = azurerm_resource_group.main.location
  environment                   = var.environment
  project_name                  = var.project_name
  managed_identity_principal_id = module.security.managed_identity_principal_id

  tags = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }
}

# IoT Module
module "iot" {
  source = "./modules/iot"

  resource_group_name       = azurerm_resource_group.main.name
  location                  = azurerm_resource_group.main.location
  environment               = var.environment
  project_name              = var.project_name
  managed_identity_id       = module.security.managed_identity_id
  storage_connection_string = module.storage.storage_primary_connection_string
  telemetry_container_name  = module.storage.telemetry_container_name

  tags = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }
}

# SQL Module
module "sql" {
  source = "./modules/sql"

  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  project_name        = var.project_name
  sql_admin_password  = var.sql_admin_password
  aad_admin_username  = "petrickmccarver@outlook.com"
  aad_admin_object_id = "7ebb1189-72b6-4256-b8ea-0a84ddd6aba0"

  tags = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }
}