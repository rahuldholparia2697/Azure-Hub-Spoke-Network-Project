#-------------------------------------------------------------
# Module: firewall
# Deploys an Azure Firewall with a Firewall Policy
# containing default network and application rule collections.
#-------------------------------------------------------------

resource "azurerm_public_ip" "firewall" {
  name                = "pip-afw-${var.hub_identifier}"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = var.tags
}

# ── Firewall Policy ─────────────────────────────────────────
resource "azurerm_firewall_policy" "firewall_policy" {
  name                     = "afwp-${var.hub_identifier}"
  location                 = var.location
  resource_group_name      = var.resource_group_name
  sku                      = "Premium"
  threat_intelligence_mode = "Alert"

  dns {
    proxy_enabled = true
  }

  intrusion_detection {
    mode = "Alert"
  }

  tags = var.tags
}

# ── Firewall instance ───────────────────────────────────────
resource "azurerm_firewall" "firewall_instance" {
  name                = "afw-hub"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Premium"
  firewall_policy_id  = azurerm_firewall_policy.firewall_policy.id
  zones               = ["1", "2", "3"]

  ip_configuration {
    name                 = "fw-ipconfig"
    subnet_id            = var.firewall_subnet_id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }

  tags = var.tags
}

# ── Network rule collections ────────────────────────────────
resource "azurerm_firewall_policy_rule_collection_group" "network_rules" {
  name               = "rcg-network-rules"
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id
  priority           = 100

  network_rule_collection {
    name     = "allow-spoke-to-spoke"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "permit-inter-spoke"
      protocols             = ["Any"]
      source_addresses      = var.spoke_address_spaces
      destination_addresses = var.spoke_address_spaces
      destination_ports     = ["*"]
    }
  }

  network_rule_collection {
    name     = "allow-dns-egress"
    priority = 110
    action   = "Allow"

    rule {
      name                  = "permit-dns-udp"
      protocols             = ["UDP"]
      source_addresses      = var.spoke_address_spaces
      destination_addresses = ["*"]
      destination_ports     = ["53"]
    }
  }
}

# ── Application rule collections ────────────────────────────
resource "azurerm_firewall_policy_rule_collection_group" "application_rules" {
  name               = "rcg-application-rules"
  firewall_policy_id = azurerm_firewall_policy.firewall_policy.id
  priority           = 200

  application_rule_collection {
    name     = "allow-azure-platform"
    priority = 100
    action   = "Allow"

    rule {
      name             = "permit-azure-management-endpoints"
      source_addresses = var.spoke_address_spaces
      destination_fqdns = [
        "*.azure.com",
        "*.microsoft.com",
        "*.windows.net",
        "*.azure-automation.net",
      ]
      protocols {
        type = "Https"
        port = 443
      }
    }
  }

  application_rule_collection {
    name     = "allow-os-updates"
    priority = 110
    action   = "Allow"

    rule {
      name             = "permit-ubuntu-repositories"
      source_addresses = var.spoke_address_spaces
      destination_fqdns = [
        "*.ubuntu.com",
        "*.canonical.com",
      ]
      protocols {
        type = "Http"
        port = 80
      }
      protocols {
        type = "Https"
        port = 443
      }
    }
  }
}
