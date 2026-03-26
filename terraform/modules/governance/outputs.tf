output "deny_public_ip_policy_id" {
  description = "ID of the deny public IP policy assignment"
  value       = azurerm_resource_group_policy_assignment.deny_public_ip.id
}
