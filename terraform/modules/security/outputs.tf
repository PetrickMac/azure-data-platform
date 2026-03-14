
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

output "managed_identity_id" {
  description = "Resource ID of the user-assigned managed identity"
  value       = azurerm_user_assigned_identity.main.id
}

output "managed_identity_client_id" {
  description = "Client ID of the managed identity — used by applications to authenticate"
  value       = azurerm_user_assigned_identity.main.client_id
}