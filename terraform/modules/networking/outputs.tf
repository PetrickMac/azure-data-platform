output "hub_vnet_id" {
  description = "ID of the hub VNet"
  value       = azurerm_virtual_network.hub.id
}

output "spoke_vnet_id" {
  description = "ID of the spoke VNet"
  value       = azurerm_virtual_network.spoke.id
}

output "hub_vnet_name" {
  description = "Name of the hub VNet"
  value       = azurerm_virtual_network.hub.name
}

output "spoke_vnet_name" {
  description = "Name of the spoke VNet"
  value       = azurerm_virtual_network.spoke.name
}

output "spoke_web_subnet_id" {
  description = "ID of the web subnet"
  value       = azurerm_subnet.spoke_web.id
}

output "spoke_app_subnet_id" {
  description = "ID of the app subnet"
  value       = azurerm_subnet.spoke_app.id
}

output "spoke_data_subnet_id" {
  description = "ID of the data subnet"
  value       = azurerm_subnet.spoke_data.id
}
/*
# output "firewall_private_ip" {
#   description = "Private IP of the Azure Firewall — used as next hop in route tables"
#   value       = azurerm_firewall.hub.ip_configuration[0].private_ip_address
# }
# output "firewall_public_ip" {
#   description = "Public IP of the Azure Firewall"
#   value       = azurerm_public_ip.firewall.ip_address
# }
*/