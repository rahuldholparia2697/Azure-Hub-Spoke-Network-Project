variable "spoke_key" {
  description = "Short identifier for the spoke being peered"
  type        = string
}

variable "hub_resource_group_name" {
  description = "Resource group containing the hub VNet"
  type        = string
}

variable "hub_vnet_name" {
  description = "Name of the hub virtual network"
  type        = string
}

variable "hub_vnet_id" {
  description = "Resource ID of the hub virtual network"
  type        = string
}

variable "spoke_resource_group_name" {
  description = "Resource group containing the spoke VNet"
  type        = string
}

variable "spoke_vnet_name" {
  description = "Name of the spoke virtual network"
  type        = string
}

variable "spoke_vnet_id" {
  description = "Resource ID of the spoke virtual network"
  type        = string
}

variable "enable_vpn_gateway" {
  description = "When true, gateway transit is enabled on hub side and remote gateways used on spoke side"
  type        = bool
  default     = true
}

variable "vpn_gateway_id" {
  description = "Resource ID of the VPN Gateway (used as implicit dependency; may be null)"
  type        = string
  default     = null
}
