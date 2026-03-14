output "resource_group_name" {
  description = "Name of the main resource group"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Location of the main resource group"
  value       = azurerm_resource_group.main.location
}

output "key_vault_uri" {
  description = "URI of the Key Vault"
  value       = module.security.key_vault_uri
}

output "managed_identity_id" {
  description = "Resource ID of the managed identity"
  value       = module.security.managed_identity_id
}

output "managed_identity_client_id" {
  description = "Client ID of the managed identity"
  value       = module.security.managed_identity_client_id
}