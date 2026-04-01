output "firewall_id" {
  description = "Resource ID of the Azure Firewall"
  value       = azurerm_firewall.firewall_instance.id
}

output "private_ip_address" {
  description = "Private IP address of the Azure Firewall"
  value       = azurerm_firewall.firewall_instance.ip_configuration[0].private_ip_address
}

output "public_ip_address" {
  description = "Public IP address of the Azure Firewall"
  value       = azurerm_public_ip.firewall.ip_address
}

output "policy_id" {
  description = "Resource ID of the Firewall Policy"
  value       = azurerm_firewall_policy.firewall_policy.id
}
