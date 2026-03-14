
# Key Vault
# Stores all secrets, connection strings, and certificates for the project.
# RBAC authorization is enabled — access is controlled through role assignments
# rather than legacy access policies. The name includes initials to ensure
# global uniqueness since Key Vault names are unique across all of Azure.

resource "azurerm_key_vault" "main" {
  name                       = "kv-${var.project_name}-${var.environment}-ptm"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7
  purge_protection_enabled   = false
  enable_rbac_authorization  = true
  tags                       = var.tags
}

# Pull current client config — needed for tenant_id and object_id
data "azurerm_client_config" "current" {}

# Grant current user Key Vault Administrator
resource "azurerm_role_assignment" "kv_admin" {
  scope                = azurerm_key_vault.main.id
  role_definition_name = "Key Vault Administrator"
  principal_id         = data.azurerm_client_config.current.object_id
}