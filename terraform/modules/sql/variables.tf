
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

variable "sql_admin_username" {
  description = "SQL administrator login username"
  type        = string
  default     = "sqladmin"
}

variable "sql_admin_password" {
  description = "SQL administrator login password"
  type        = string
  sensitive   = true
}

variable "aad_admin_username" {
  description = "Azure AD administrator display name"
  type        = string
}

variable "aad_admin_object_id" {
  description = "Object ID of the Azure AD administrator"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "sql_location" {
  description = "Azure region for SQL resources — may differ from main location due to quota restrictions"
  type        = string
  default     = "westus2"
}