output "resource_group_name" {
  description = "Name of the hub resource group"
  value       = azurerm_resource_group.hub_rg.name
}

output "vnet_id" {
  description = "Resource ID of the hub virtual network"
  value       = azurerm_virtual_network.hub_network.id
}

output "vnet_name" {
  description = "Name of the hub virtual network"
  value       = azurerm_virtual_network.hub_network.name
}

output "firewall_subnet_id" {
  description = "Resource ID of AzureFirewallSubnet"
  value       = azurerm_subnet.firewall.id
}

output "gateway_subnet_id" {
  description = "Resource ID of GatewaySubnet (null when VPN gateway is disabled)"
  value       = var.enable_vpn_gateway ? azurerm_subnet.gateway[0].id : null
}

output "bastion_subnet_id" {
  description = "Resource ID of AzureBastionSubnet (null when Bastion is disabled)"
  value       = var.enable_bastion ? azurerm_subnet.bastion[0].id : null
}

output "management_subnet_id" {
  description = "Resource ID of the management subnet"
  value       = azurerm_subnet.management.id
}
