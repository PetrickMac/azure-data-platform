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
