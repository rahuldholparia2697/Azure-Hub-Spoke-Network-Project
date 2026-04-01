variable "spoke_key" {
  description = "Short identifier for the spoke these routes belong to"
  type        = string
}

variable "location" {
  description = "Azure region for the route table"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the route table is created"
  type        = string
}

variable "spoke_subnet_ids" {
  description = "Map of subnet keys to resource IDs for route table association"
  type        = map(string)
}

variable "all_spoke_vnets" {
  description = "Full spoke_vnets map (used to generate inter-spoke routes)"
  type = map(object({
    address_space = list(string)
    subnets       = map(any)
  }))
}

variable "firewall_private_ip" {
  description = "Private IP of the Azure Firewall used as next-hop"
  type        = string
}

variable "tags" {
  description = "Tags applied to every resource in this module"
  type        = map(string)
  default     = {}
}
