
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
}

variable "project_name" {
  description = "Project name — used in resource naming"
  type        = string
}

variable "managed_identity_id" {
  description = "Resource ID of the user-assigned managed identity"
  type        = string
}

variable "storage_connection_string" {
  description = "Connection string for the storage account receiving telemetry"
  type        = string
  sensitive   = true
}

variable "telemetry_container_name" {
  description = "Name of the blob container for raw telemetry data"
  type        = string
  default     = "telemetry-raw"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}