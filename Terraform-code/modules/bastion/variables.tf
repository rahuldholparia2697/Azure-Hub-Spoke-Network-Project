variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where Bastion is deployed"
  type        = string
}

variable "bastion_subnet_id" {
  description = "Resource ID of AzureBastionSubnet (may be null when enable_bastion is false)"
  type        = string
  default     = null
}

variable "enable_bastion" {
  description = "Controls whether Bastion resources are created"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to every resource in this module"
  type        = map(string)
  default     = {}
}
