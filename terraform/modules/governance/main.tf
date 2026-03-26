# Policy: Deny Public IP creation
resource "azurerm_resource_group_policy_assignment" "deny_public_ip" {
  name                 = "deny-public-ip"
  resource_group_id    = var.resource_group_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114"
  description          = "Deny creation of public IP addresses in the resource group"
}

# Policy: Require tags on resources
resource "azurerm_resource_group_policy_assignment" "require_tags" {
  name                 = "require-project-tag"
  resource_group_id    = var.resource_group_id
  policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
  description          = "Require project tag on all resources"

  parameters = jsonencode({
    tagName = { value = "project" }
  })
}
