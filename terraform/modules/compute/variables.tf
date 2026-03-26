variable "environment" {
  description = "Environment name"
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

variable "web_subnet_id" {
  description = "Subnet ID for the web VM"
  type        = string
}

variable "ssh_public_key" {
  description = "SSH public key for VM authentication"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}
