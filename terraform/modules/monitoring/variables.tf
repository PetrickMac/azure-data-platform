variable "environment" {
  description = "Environment name (e.g., dev)"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

variable "key_vault_id" {
  description = "Resource ID of Key Vault for diagnostic settings"
  type        = string
}

variable "iot_hub_id" {
  description = "Resource ID of IoT Hub for diagnostic settings"
  type        = string
}

variable "resource_group_id" {
  description = "Resource group ID for role assignments"
  type        = string
}

variable "admin_object_id" {
  description = "Object ID of the admin user for Grafana access"
  type        = string
}