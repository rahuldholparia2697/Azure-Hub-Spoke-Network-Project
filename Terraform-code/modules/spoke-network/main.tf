#-------------------------------------------------------------
# Module: spoke-network
# Provisions a single spoke: resource group, virtual network,
# subnets (with optional delegations), NSGs, and associations.
#-------------------------------------------------------------

resource "azurerm_resource_group" "spoke_rg" {
  name     = "rg-network-spoke-${var.spoke_key}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_virtual_network" "virtual_network" {
  name                = "vnet-spoke-${var.spoke_key}"
  location            = azurerm_resource_group.spoke_rg.location
  resource_group_name = azurerm_resource_group.spoke_rg.name
  address_space       = var.spoke_config.address_space
  tags                = var.tags
}

# ── Subnets ─────────────────────────────────────────────────
resource "azurerm_subnet" "subnet" {
  for_each = var.spoke_config.subnets

  name                 = "snet-${var.spoke_key}-${each.key}"
  resource_group_name  = azurerm_resource_group.spoke_rg.name
  virtual_network_name = azurerm_virtual_network.virtual_network.name
  address_prefixes     = [each.value.address_prefix]
  service_endpoints    = each.value.service_endpoints

  dynamic "delegation" {
    for_each = each.value.delegation != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}

# ── NSGs (one per subnet) ───────────────────────────────────
resource "azurerm_network_security_group" "nsg" {
  for_each = var.spoke_config.subnets

  name                = "nsg-${var.spoke_key}-${each.key}"
  location            = azurerm_resource_group.spoke_rg.location
  resource_group_name = azurerm_resource_group.spoke_rg.name
  tags                = var.tags
}

resource "azurerm_subnet_network_security_group_association" "nsg_association" {
  for_each = var.spoke_config.subnets

  subnet_id                 = azurerm_subnet.subnet[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.key].id
}
