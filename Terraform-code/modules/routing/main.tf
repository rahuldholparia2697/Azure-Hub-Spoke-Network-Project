#-------------------------------------------------------------
# Module: routing
# Creates a UDR route table for a single spoke and attaches
# it to every subnet in that spoke. All internet and
# inter-spoke traffic is steered through Azure Firewall.
#-------------------------------------------------------------

resource "azurerm_route_table" "route_table" {
  name                = "rt-spoke-${var.spoke_key}"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# ── Default route: internet traffic via Firewall ────────────
resource "azurerm_route" "internet_via_firewall" {
  name                   = "udr-internet-via-firewall"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.route_table.name
  address_prefix         = "0.0.0.0/0"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewall_private_ip
}

# ── Spoke-to-spoke routes via Firewall ──────────────────────
# One route per remote spoke, directing cross-spoke traffic
# through the hub firewall rather than direct peering.
resource "azurerm_route" "spoke_to_spoke" {
  for_each = {
    for remote_key, remote_spoke in var.all_spoke_vnets :
    remote_key => remote_spoke
    if remote_key != var.spoke_key
  }

  name                   = "udr-to-spoke-${each.key}"
  resource_group_name    = var.resource_group_name
  route_table_name       = azurerm_route_table.route_table.name
  address_prefix         = each.value.address_space[0]
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = var.firewall_private_ip
}

# ── Associate route table with every subnet in this spoke ───
resource "azurerm_subnet_route_table_association" "RT_association" {
  for_each = var.spoke_subnet_ids

  subnet_id      = each.value
  route_table_id = azurerm_route_table.route_table.id
}
