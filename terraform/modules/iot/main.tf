
# Azure IoT Hub
# Receives telemetry from simulated edge devices and routes messages
# to downstream services. This mirrors the edge-to-cloud pattern used
# by the IoT software team. The managed identity is attached so IoT Hub
# can authenticate to other Azure services without credentials.

resource "azurerm_iothub" "main" {
  name                = "iot-${var.project_name}-${var.environment}-ptm"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
  min_tls_version     = "1.2"

  sku {
    name     = "S1"
    capacity = 1
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.managed_identity_id]
  }
}

# IoT Hub message route — sends device telemetry to Storage
resource "azurerm_iothub_route" "telemetry_to_storage" {
  resource_group_name = var.resource_group_name
  iothub_name         = azurerm_iothub.main.name
  name                = "route-telemetry-to-storage"
  source              = "DeviceMessages"
  condition           = "true"
  endpoint_names      = [azurerm_iothub_endpoint_storage_container.telemetry.name]
  enabled             = true
}

# IoT Hub storage endpoint — landing zone for raw telemetry
resource "azurerm_iothub_endpoint_storage_container" "telemetry" {
  resource_group_name = var.resource_group_name
  iothub_id           = azurerm_iothub.main.id
  name                = "endpoint-telemetry-storage"
  connection_string   = var.storage_connection_string
  container_name      = var.telemetry_container_name
  encoding            = "JSON"
  file_name_format    = "{iothub}/{partition}/{YYYY}/{MM}/{DD}/{HH}/{mm}"
}