
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

variable "web_subnet_id" {
  description = "ID of the web subnet"
  type        = string
}

variable "app_subnet_id" {
  description = "ID of the app subnet"
  type        = string
}

variable "data_subnet_id" {
  description = "ID of the data subnet"
  type        = string
}

variable "web_subnet_cidr" {
  description = "CIDR of the web subnet — used as source in app NSG rule"
  type        = string
}

variable "app_subnet_cidr" {
  description = "CIDR of the app subnet — used as source in data NSG rule"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}