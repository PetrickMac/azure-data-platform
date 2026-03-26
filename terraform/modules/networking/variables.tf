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

variable "hub_vnet_cidr" {
  description = "Address space for the hub VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "spoke_vnet_cidr" {
  description = "Address space for the spoke VNet"
  type        = string
  default     = "10.1.0.0/16"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "storage_account_id" {
  description = "Storage account resource ID for Private Endpoint"
  type        = string
}

variable "sql_server_id" {
  description = "SQL Server resource ID for Private Endpoint"
  type        = string
}
