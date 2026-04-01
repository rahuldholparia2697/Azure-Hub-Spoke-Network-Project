output "gateway_id" {
  description = "Resource ID of the VPN Gateway (null when disabled)"
  value       = var.enable_vpn_gateway ? azurerm_virtual_network_gateway.vpn_gateway_instance[0].id : null
}

output "public_ip_address" {
  description = "Public IP address of the VPN Gateway (null when disabled)"
  value       = var.enable_vpn_gateway ? azurerm_public_ip.vpn_gateway[0].ip_address : null
}
