variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group where the firewall is deployed"
  type        = string
}

variable "firewall_subnet_id" {
  description = "Resource ID of AzureFirewallSubnet"
  type        = string
}

variable "spoke_address_spaces" {
  description = "List of spoke CIDR ranges referenced in firewall rules"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "Tags applied to every resource in this module"
  type        = map(string)
  default     = {}
}
