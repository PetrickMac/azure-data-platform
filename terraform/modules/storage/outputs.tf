
output "storage_account_id" {
  description = "ID of the storage account"
  value       = azurerm_storage_account.main.id
}

output "storage_account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.main.name
}

output "storage_primary_connection_string" {
  description = "Primary connection string — used by IoT Hub endpoint"
  value       = azurerm_storage_account.main.primary_connection_string
  sensitive   = true
}

output "storage_primary_dfs_endpoint" {
  description = "Data Lake Gen2 DFS endpoint — used by Data Factory"
  value       = azurerm_storage_account.main.primary_dfs_endpoint
}

output "telemetry_container_name" {
  description = "Name of the raw telemetry container"
  value       = azurerm_storage_container.telemetry_raw.name
}