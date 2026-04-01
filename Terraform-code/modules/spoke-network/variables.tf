variable "spoke_key" {
  description = "Short identifier for this spoke (e.g. 'production', 'development')"
  type        = string
}

variable "location" {
  description = "Azure region for spoke resources"
  type        = string
}

variable "spoke_config" {
  description = "Configuration object for this spoke (address space and subnets)"
  type = object({
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
  })
}

variable "tags" {
  description = "Tags applied to every resource in this module"
  type        = map(string)
  default     = {}
}
