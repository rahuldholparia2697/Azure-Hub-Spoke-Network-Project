variable "location" {
  description = "Azure region for the Log Analytics workspace"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the workspace is placed"
  type        = string
}

variable "firewall_id" {
  description = "Resource ID of the Azure Firewall"
  type        = string
}

variable "vpn_gateway_id" {
  description = "Resource ID of the VPN Gateway (may be null)"
  type        = string
  default     = null
}

variable "bastion_id" {
  description = "Resource ID of Azure Bastion (may be null)"
  type        = string
  default     = null
}

variable "enable_vpn_gateway" {
  description = "Controls whether VPN Gateway diagnostic settings are created"
  type        = bool
  default     = true
}

variable "enable_bastion" {
  description = "Controls whether Bastion diagnostic settings are created"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "Number of days to retain logs in the workspace"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Tags applied to every resource in this module"
  type        = map(string)
  default     = {}
}
