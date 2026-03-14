
output "web_nsg_id" {
  description = "ID of the web NSG"
  value       = azurerm_network_security_group.web.id
}

output "app_nsg_id" {
  description = "ID of the app NSG"
  value       = azurerm_network_security_group.app.id
}

output "data_nsg_id" {
  description = "ID of the data NSG"
  value       = azurerm_network_security_group.data.id
}

output "key_vault_id" {
  description = "ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_uri" {
  description = "URI of the Key Vault — used by applications to retrieve secrets"
  value       = azurerm_key_vault.main.vault_uri
}