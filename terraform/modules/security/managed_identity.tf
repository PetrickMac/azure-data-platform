
# Managed Identity — used by Azure services to authenticate to Key Vault
# and other Azure resources without storing credentials anywhere.
# This identity will be assigned to IoT Hub, Data Factory, and other
# services as they are added to the project.

resource "azurerm_user_assigned_identity" "main" {
  name                = "id-${var.project_name}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# Grant the Managed Identity access to read secrets from Key Vault
resource "azurerm_role_assignment" "kv_secrets_user" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = azurerm_user_assigned_identity.main.principal_id
}