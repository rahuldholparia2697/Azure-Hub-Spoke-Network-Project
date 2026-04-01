#----------------------------------------------------------------
# Module: hub-network
# Provisions the hub resource group, virtual network,
# and all fixed subnets (Firewall, Gateway, Bastion, Management).
#----------------------------------------------------------------

resource "azurerm_resource_group" "hub_rg" {
  name     = "rg-network-hub"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "hub_network" {
  name                = "vnet-hub"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  address_space       = var.address_space
  tags                = var.tags
}

# ── Firewall subnet (name is mandated by Azure) ─────────────
resource "azurerm_subnet" "firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_network.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 8, 0)]
}

# ── VPN Gateway subnet (conditional) ───────────────────────
resource "azurerm_subnet" "gateway" {
  count = var.enable_vpn_gateway ? 1 : 0

  name                 = "GatewaySubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_network.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 8, 1)]
}

# ── Bastion subnet (conditional; name mandated by Azure) ───
resource "azurerm_subnet" "bastion" {
  count = var.enable_bastion ? 1 : 0

  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_network.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 8, 2)]
}

# ── Management subnet ───────────────────────────────────────
resource "azurerm_subnet" "management" {
  name                 = "snet-management"
  resource_group_name  = azurerm_resource_group.hub_rg.name
  virtual_network_name = azurerm_virtual_network.hub_network.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 8, 3)]

  service_endpoints = [
    "Microsoft.KeyVault",
    "Microsoft.Storage",
  ]
}

# ── NSG for the management subnet ──────────────────────────
resource "azurerm_network_security_group" "management" {
  name                = "nsg-hub-mgmt"
  location            = azurerm_resource_group.hub_rg.location
  resource_group_name = azurerm_resource_group.hub_rg.name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "management" {
  subnet_id                 = azurerm_subnet.management.id
  network_security_group_id = azurerm_network_security_group.management.id
}
