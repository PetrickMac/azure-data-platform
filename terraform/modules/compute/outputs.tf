output "web_vm_id" {
  description = "ID of the web VM"
  value       = azurerm_linux_virtual_machine.web.id
}

output "web_vm_private_ip" {
  description = "Private IP of the web VM"
  value       = azurerm_network_interface.web_vm.private_ip_address
}

output "web_vm_name" {
  description = "Name of the web VM"
  value       = azurerm_linux_virtual_machine.web.name
}

output "acr_login_server" {
  description = "ACR login server URL"
  value       = azurerm_container_registry.main.login_server
}

output "acr_name" {
  description = "ACR name"
  value       = azurerm_container_registry.main.name
}
