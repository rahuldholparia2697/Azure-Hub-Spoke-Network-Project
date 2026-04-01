#-------------------------------------------------------------
# Module: monitoring
# Provisions a Log Analytics workspace and attaches diagnostic
# settings to Firewall, VPN Gateway, and Bastion.
#-------------------------------------------------------------

resource "azurerm_log_analytics_workspace" "law" {
  name                = "log-network"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
  tags                = var.tags
}

# ── Firewall diagnostics ─────────────────────────────────────
resource "azurerm_monitor_diagnostic_setting" "firewall" {
  name                       = "diag-firewall"
  target_resource_id         = var.firewall_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log { category = "AzureFirewallApplicationRule" }
  enabled_log { category = "AzureFirewallNetworkRule" }
  enabled_log { category = "AzureFirewallDnsProxy" }

  enabled_metric { category = "AllMetrics" }
}

# ── VPN Gateway diagnostics (conditional) ───────────────────
resource "azurerm_monitor_diagnostic_setting" "vpn_gateway" {
  count = var.enable_vpn_gateway ? 1 : 0

  name                       = "diag-vpngw"
  target_resource_id         = var.vpn_gateway_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log { category = "GatewayDiagnosticLog" }
  enabled_log { category = "TunnelDiagnosticLog" }
  enabled_log { category = "RouteDiagnosticLog" }
  enabled_log { category = "IKEDiagnosticLog" }

  enabled_metric { category = "AllMetrics" }
}

# ── Bastion diagnostics (conditional) ───────────────────────
resource "azurerm_monitor_diagnostic_setting" "bastion" {
  count = var.enable_bastion ? 1 : 0

  name                       = "diag-bastion"
  target_resource_id         = var.bastion_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id

  enabled_log { category = "BastionAuditLogs" }

  enabled_metric { category = "AllMetrics" }
}
