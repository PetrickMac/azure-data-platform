
output "iothub_id" {
  description = "ID of the IoT Hub"
  value       = azurerm_iothub.main.id
}

output "iothub_name" {
  description = "Name of the IoT Hub"
  value       = azurerm_iothub.main.name
}

output "iothub_hostname" {
  description = "Hostname of the IoT Hub — used by devices to connect"
  value       = azurerm_iothub.main.hostname
}