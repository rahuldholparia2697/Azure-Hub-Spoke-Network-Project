variable "location" {
  description = "Azure region for hub resources"
  type        = string
}

variable "address_space" {
  description = "CIDR block(s) assigned to the hub virtual network"
  type        = list(string)
}

variable "enable_vpn_gateway" {
  description = "When true the GatewaySubnet is provisioned"
  type        = bool
  default     = true
}

variable "enable_bastion" {
  description = "When true the AzureBastionSubnet is provisioned"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to every resource in this module"
  type        = map(string)
  default     = {}
}
