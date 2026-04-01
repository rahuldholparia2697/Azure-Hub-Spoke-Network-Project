output "bastion_id" {
  description = "Resource ID of the Azure Bastion host (null when disabled)"
  value       = var.enable_bastion ? azurerm_bastion_host.bastion_instance[0].id : null
}

output "bastion_fqdn" {
  description = "DNS name of the Azure Bastion host (null when disabled)"
  value       = var.enable_bastion ? azurerm_bastion_host.bastion_instance[0].dns_name : null
}
