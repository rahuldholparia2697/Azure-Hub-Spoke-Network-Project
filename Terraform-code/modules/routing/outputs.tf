output "route_table_id" {
  description = "Resource ID of the spoke route table"
  value       = azurerm_route_table.route_table.id
}

output "route_table_name" {
  description = "Name of the spoke route table"
  value       = azurerm_route_table.route_table.name
}
