resource "azurerm_data_factory" "main" {
  name                = "adf-adp-${var.environment}-ptm"
  location            = var.location
  resource_group_name = var.resource_group_name

  identity {
    type         = "UserAssigned"
    identity_ids = [var.managed_identity_id]
  }

  tags = var.tags
}
