
# Azure Storage Account — Data Lake Gen2
# Landing zone for all raw data in the project. Hierarchical namespace
# is enabled which makes this a Data Lake Gen2 — optimized for analytics
# workloads. IoT Hub routes device telemetry here. Data Factory reads
# from here and loads into SQL. Public access is disabled — all access
# is through private endpoints or managed identities.

resource "azurerm_storage_account" "main" {
  name                     = "st${var.project_name}${var.environment}ptm"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  is_hns_enabled           = true
  min_tls_version          = "TLS1_2"

  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }

  tags = var.tags
}

# Raw telemetry container — IoT Hub writes here
resource "azurerm_storage_container" "telemetry_raw" {
  name                  = "telemetry-raw"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Raw data container — Data Factory source files
resource "azurerm_storage_container" "raw" {
  name                  = "raw"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Processed data container — transformed data before SQL load
resource "azurerm_storage_container" "processed" {
  name                  = "processed"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

# Grant managed identity Storage Blob Data Contributor on this account
resource "azurerm_role_assignment" "storage_identity" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = var.managed_identity_principal_id
}