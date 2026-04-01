variable "subscription_id" {
  description = "Azure subscription ID where resources will be deployed"
  type        = string
  sensitive   = true
}

variable "location" {
  description = "Primary Azure region for all resources"
  type        = string
  default     = "uksouth"
}

variable "hub_vnet_address_space" {
  description = "CIDR address space for the hub virtual network"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "spoke_vnets" {
  description = "Map of spoke virtual networks to create, keyed by a short identifier"
  type = map(object({
    address_space = list(string)
    subnets = map(object({
      address_prefix    = string
      service_endpoints = optional(list(string), [])
      delegation = optional(object({
        name = string
        service_delegation = object({
          name    = string
          actions = optional(list(string), [])
        })
      }))
    }))
  }))
  default = {}
}

variable "enable_vpn_gateway" {
  description = "Deploy a VPN Gateway in the hub network"
  type        = bool
  default     = true
}

variable "enable_bastion" {
  description = "Deploy Azure Bastion in the hub network"
  type        = bool
  default     = true
}

variable "on_premises_address_spaces" {
  description = "On-premises CIDR ranges advertised over VPN (used for local network gateway)"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Additional tags to merge onto every resource"
  type        = map(string)
  default     = {}
}
