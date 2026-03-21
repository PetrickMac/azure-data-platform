resource "azurerm_dashboard_grafana" "main" {
  name                              = "grafana-adp-${var.environment}"
  location                          = var.location
  resource_group_name               = var.resource_group_name
  grafana_major_version             = 12
  api_key_enabled                   = false
  deterministic_outbound_ip_enabled = false
  public_network_access_enabled     = true

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Grant Grafana's identity read access to your monitoring data
resource "azurerm_role_assignment" "grafana_monitoring_reader" {
  scope                = var.resource_group_id
  role_definition_name = "Monitoring Reader"
  principal_id         = azurerm_dashboard_grafana.main.identity[0].principal_id
}

# Grant your user Grafana Admin so you can access the dashboards
resource "azurerm_role_assignment" "grafana_admin" {
  scope                = azurerm_dashboard_grafana.main.id
  role_definition_name = "Grafana Admin"
  principal_id         = var.admin_object_id
}
