variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the gateway is deployed"
  type        = string
}

variable "gateway_subnet_id" {
  description = "Resource ID of GatewaySubnet (may be null when enable_vpn_gateway is false)"
  type        = string
  default     = null
}

variable "enable_vpn_gateway" {
  description = "Controls whether VPN Gateway resources are created"
  type        = bool
  default     = true
}

variable "bgp_asn" {
  description = "BGP Autonomous System Number for the VPN Gateway"
  type        = number
  default     = 65515
}

variable "on_premises_address_spaces" {
  description = "On-premises CIDR ranges (reserved for future local network gateway use)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to every resource in this module"
  type        = map(string)
  default     = {}
}
