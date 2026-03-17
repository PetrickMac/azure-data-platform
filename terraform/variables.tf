
variable "project_name" {
  description = "Name of the project — used in all resource names"
  type        = string
  default     = "adp"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "eastus"
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

variable "sql_admin_password" {
  description = "SQL administrator password — set via TF_VAR_sql_admin_password environment variable"
  type        = string
  sensitive   = true
}