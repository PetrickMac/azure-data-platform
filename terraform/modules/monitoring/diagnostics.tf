# Key Vault diagnostic settings — audit events
resource "azurerm_monitor_diagnostic_setting" "keyvault" {
  name                       = "diag-keyvault-to-log"
  target_resource_id         = var.key_vault_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "AuditEvent"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# IoT Hub diagnostic settings — connections and telemetry
resource "azurerm_monitor_diagnostic_setting" "iothub" {
  name                       = "diag-iothub-to-log"
  target_resource_id         = var.iot_hub_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "Connections"
  }

  enabled_log {
    category = "DeviceTelemetry"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
