output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.name
}

output "grafana_endpoint" {
  description = "URL of the Grafana dashboard"
  value       = azurerm_dashboard_grafana.main.endpoint
}