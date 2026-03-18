output "data_factory_id" {
  description = "ID of the Data Factory"
  value       = azurerm_data_factory.main.id
}

output "data_factory_name" {
  description = "Name of the Data Factory"
  value       = azurerm_data_factory.main.name
}
