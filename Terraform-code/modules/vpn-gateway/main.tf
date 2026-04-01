#-------------------------------------------------------------
# Module: vpn-gateway
# Conditionally deploys an Active/Passive VPN Gateway
# (Generation 2, BGP-enabled) in the hub network.
#-------------------------------------------------------------

resource "azurerm_public_ip" "vpn_gateway" {
  count = var.enable_vpn_gateway ? 1 : 0

  name                = "pip-vpngw-hub"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = var.tags
}

resource "azurerm_virtual_network_gateway" "vpn_gateway_instance" {
  count = var.enable_vpn_gateway ? 1 : 0

  name                = "vpngw-hub"
  location            = var.location
  resource_group_name = var.resource_group_name

  type       = "Vpn"
  vpn_type   = "RouteBased"
  sku        = "VpnGw2AZ"
  generation = "Generation2"

  active_active = false
  bgp_enabled   = true

  ip_configuration {
    name                          = "gwipconfig"
    public_ip_address_id          = azurerm_public_ip.vpn_gateway[0].id
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.gateway_subnet_id
  }

  bgp_settings {
    asn = var.bgp_asn
  }

  tags = var.tags
}
