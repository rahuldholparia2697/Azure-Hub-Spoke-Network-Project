output "hub_vnet_id" {
  description = "Resource ID of the hub virtual network"
  value       = module.hub_network.vnet_id
}

output "hub_vnet_name" {
  description = "Name of the hub virtual network"
  value       = module.hub_network.vnet_name
}

output "firewall_private_ip" {
  description = "Private IP address of the Azure Firewall"
  value       = module.firewall.private_ip_address
}

output "spoke_vnet_ids" {
  description = "Map of spoke names to their virtual network resource IDs"
  value       = { for k, v in module.spoke_networks : k => v.vnet_id }
}

output "spoke_subnet_ids" {
  description = "Map of spoke subnet keys to their resource IDs"
  value       = { for k, v in module.spoke_networks : k => v.subnet_ids }
}

output "bastion_fqdn" {
  description = "DNS name of the Azure Bastion host (null when Bastion is disabled)"
  value       = module.bastion.bastion_fqdn
}

output "vpn_gateway_public_ip" {
  description = "Public IP address of the VPN Gateway (null when gateway is disabled)"
  value       = module.vpn_gateway.public_ip_address
}

output "log_analytics_workspace_id" {
  description = "Resource ID of the Log Analytics workspace used for diagnostics"
  value       = module.monitoring.workspace_id
}
