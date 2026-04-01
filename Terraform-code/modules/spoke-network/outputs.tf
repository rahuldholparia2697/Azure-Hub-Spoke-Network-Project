output "resource_group_name" {
  description = "Name of the spoke resource group"
  value       = azurerm_resource_group.spoke_rg.name
}

output "vnet_id" {
  description = "Resource ID of the spoke virtual network"
  value       = azurerm_virtual_network.virtual_network.id
}

output "vnet_name" {
  description = "Name of the spoke virtual network"
  value       = azurerm_virtual_network.virtual_network.name
}

output "subnet_ids" {
  description = "Map of subnet keys to their resource IDs"
  value       = { for k, v in azurerm_subnet.subnet : k => v.id }
}

output "nsg_ids" {
  description = "Map of subnet keys to their NSG resource IDs"
  value       = { for k, v in azurerm_network_security_group.nsg : k => v.id }
}
