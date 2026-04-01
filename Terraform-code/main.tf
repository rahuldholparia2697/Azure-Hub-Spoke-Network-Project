# ──────────────────────────────────────────────────────────
# Module: Hub Network
# ──────────────────────────────────────────────────────────
module "hub_network" {
  source = "./modules/hub-network"

  location           = var.location
  address_space      = var.hub_vnet_address_space
  enable_vpn_gateway = var.enable_vpn_gateway
  enable_bastion     = var.enable_bastion
  tags               = local.base_tags
}

# ──────────────────────────────────────────────────────────
# Module: Azure Firewall
# ──────────────────────────────────────────────────────────
module "firewall" {
  source = "./modules/firewall"

  location            = var.location
  resource_group_name = module.hub_network.resource_group_name
  firewall_subnet_id  = module.hub_network.firewall_subnet_id
  spoke_address_spaces = [
    for spoke in var.spoke_vnets : spoke.address_space[0]
  ]
  tags = local.base_tags
}

# ──────────────────────────────────────────────────────────
# Module: Azure Bastion
# ──────────────────────────────────────────────────────────
module "bastion" {
  source = "./modules/bastion"

  location            = var.location
  resource_group_name = module.hub_network.resource_group_name
  bastion_subnet_id   = module.hub_network.bastion_subnet_id
  enable_bastion      = var.enable_bastion
  tags                = local.base_tags
}

# ──────────────────────────────────────────────────────────
# Module: VPN Gateway
# ──────────────────────────────────────────────────────────
module "vpn_gateway" {
  source = "./modules/vpn-gateway"

  location                   = var.location
  resource_group_name        = module.hub_network.resource_group_name
  gateway_subnet_id          = module.hub_network.gateway_subnet_id
  enable_vpn_gateway         = var.enable_vpn_gateway
  on_premises_address_spaces = var.on_premises_address_spaces
  tags                       = local.base_tags
}

# ──────────────────────────────────────────────────────────
# Module: Spoke Networks
# ──────────────────────────────────────────────────────────
module "spoke_networks" {
  source = "./modules/spoke-network"

  for_each = var.spoke_vnets

  spoke_key    = each.key
  location     = var.location
  spoke_config = each.value
  tags         = local.base_tags
}

# ──────────────────────────────────────────────────────────
# Module: VNet Peering (hub ↔ spokes)
# ──────────────────────────────────────────────────────────
module "peering" {
  source = "./modules/peering"

  for_each = var.spoke_vnets

  spoke_key                 = each.key
  hub_resource_group_name   = module.hub_network.resource_group_name
  hub_vnet_name             = module.hub_network.vnet_name
  hub_vnet_id               = module.hub_network.vnet_id
  spoke_resource_group_name = module.spoke_networks[each.key].resource_group_name
  spoke_vnet_name           = module.spoke_networks[each.key].vnet_name
  spoke_vnet_id             = module.spoke_networks[each.key].vnet_id
  enable_vpn_gateway        = var.enable_vpn_gateway
  vpn_gateway_id            = module.vpn_gateway.gateway_id

  depends_on = [module.vpn_gateway]
}

# ──────────────────────────────────────────────────────────
# Module: Routing (UDRs forcing traffic via firewall)
# ──────────────────────────────────────────────────────────
module "routing" {
  source = "./modules/routing"

  for_each = var.spoke_vnets

  spoke_key           = each.key
  location            = var.location
  resource_group_name = module.spoke_networks[each.key].resource_group_name
  spoke_subnet_ids    = module.spoke_networks[each.key].subnet_ids
  all_spoke_vnets     = var.spoke_vnets
  firewall_private_ip = module.firewall.private_ip_address
  tags                = local.base_tags
}

# ──────────────────────────────────────────────────────────
# Module: Monitoring & Diagnostics
# ──────────────────────────────────────────────────────────
module "monitoring" {
  source = "./modules/monitoring"

  location            = var.location
  resource_group_name = module.hub_network.resource_group_name
  firewall_id         = module.firewall.firewall_id
  vpn_gateway_id      = module.vpn_gateway.gateway_id
  bastion_id          = module.bastion.bastion_id
  enable_vpn_gateway  = var.enable_vpn_gateway
  enable_bastion      = var.enable_bastion
  tags                = local.base_tags
}
