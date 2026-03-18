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

variable "managed_identity_id" {
  description = "User-assigned managed identity resource ID"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
