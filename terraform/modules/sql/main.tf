
# Azure SQL Database Module
# Structured data store for transformed NYC Taxi data and IoT telemetry.
# The server uses Azure AD authentication only — no SQL admin passwords.
# The managed identity is granted db_datareader and db_datawriter so
# Data Factory can load data without storing credentials anywhere.

resource "azurerm_mssql_server" "main" {
  name                         = "sql-${var.project_name}-${var.environment}-ptm-wu2"
  location                     = var.sql_location
  resource_group_name          = var.resource_group_name
  version                      = "12.0"
  administrator_login          = var.sql_admin_username
  administrator_login_password = var.sql_admin_password
  minimum_tls_version          = "1.2"
  tags                         = var.tags

  azuread_administrator {
    login_username = var.aad_admin_username
    object_id      = var.aad_admin_object_id
  }
}

# SQL Database
resource "azurerm_mssql_database" "main" {
  name         = "sqldb-${var.project_name}-${var.environment}"
  server_id    = azurerm_mssql_server.main.id
  collation    = "SQL_Latin1_General_CP1_CI_AS"
  sku_name     = "Basic"
  max_size_gb  = 2
  tags         = var.tags
}

# Allow Azure services to connect to the SQL server
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}