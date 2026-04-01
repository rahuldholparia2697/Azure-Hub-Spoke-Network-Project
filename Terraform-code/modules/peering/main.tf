#-------------------------------------------------------------
# Module: peering
# Creates a bidirectional VNet peering between the hub and
# a single spoke. Call once per spoke via for_each.
#-------------------------------------------------------------

# ── Hub → Spoke ─────────────────────────────────────────────
resource "azurerm_virtual_network_peering" "hub_to_spoke" {
  name                      = "peer-hub-to-${var.spoke_key}"
  resource_group_name       = var.hub_resource_group_name
  virtual_network_name      = var.hub_vnet_name
  remote_virtual_network_id = var.spoke_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = var.enable_vpn_gateway
  use_remote_gateways          = false
}

# ── Spoke → Hub ─────────────────────────────────────────────
resource "azurerm_virtual_network_peering" "spoke_to_hub" {
  name                      = "peer-${var.spoke_key}-to-hub"
  resource_group_name       = var.spoke_resource_group_name
  virtual_network_name      = var.spoke_vnet_name
  remote_virtual_network_id = var.hub_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = var.enable_vpn_gateway

  # Gateway must exist before the spoke can use it
  depends_on = [var.vpn_gateway_id]
}
