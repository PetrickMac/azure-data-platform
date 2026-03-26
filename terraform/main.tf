
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
  source              = "./modules/networking"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  hub_vnet_cidr       = var.hub_vnet_cidr
  spoke_vnet_cidr     = var.spoke_vnet_cidr
  storage_account_id  = module.storage.storage_account_id
  sql_server_id       = module.sql.sql_server_id
  tags = {
    project     = var.project_name
    environment = var.environment
    managed_by  = "terraform"
  }
}

# Security Module
module "security" {
  source              = "./modules/security"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = var.environment
  project_name        = var.project_name
  web_subnet_id       = module.networking.spoke_web_subnet_id
  app_subnet_id       = module.networking.spoke_app_subnet_id
  data_subnet_id      = module.networking.spoke_data_subnet_id
  web_subnet_cidr     = cidrsubnet(var.spoke_vnet_cidr, 8, 0)
  app_subnet_cidr     = cidrsubnet(var.spoke_vnet_cidr, 8, 1)
  data_subnet_cidr    = cidrsubnet(var.spoke_vnet_cidr, 8, 2)
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

module "data_factory" {
  source              = "./modules/data-factory"
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  managed_identity_id = module.security.managed_identity_id
  tags = {
    project     = var.project_name
    environment = var.environment
  }
}

module "monitoring" {
  source              = "./modules/monitoring"
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  key_vault_id        = module.security.key_vault_id
  iot_hub_id          = module.iot.iothub_id
  resource_group_id   = azurerm_resource_group.main.id
  admin_object_id     = "7ebb1189-72b6-4256-b8ea-0a84ddd6aba0"
  tags = {
    project     = var.project_name
    environment = var.environment
  }
}

module "compute" {
  source              = "./modules/compute"
  environment         = var.environment
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  web_subnet_id       = module.networking.spoke_web_subnet_id
  ssh_public_key      = file("~/.ssh/id_rsa.pub")
  tags = {
    project     = var.project_name
    environment = var.environment
  }
}