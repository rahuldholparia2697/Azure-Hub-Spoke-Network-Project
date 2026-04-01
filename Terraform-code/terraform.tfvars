subscription_id = "99c0acb2-ff53-4ac2-8e99-071411ed7ee4"
location        = "westeurope"

hub_vnet_address_space = ["10.0.0.0/16"]

spoke_vnets = {
  production = {
    address_space = ["10.1.0.0/16"]
    subnets = {
      web = {
        address_prefix    = "10.1.1.0/24"
        service_endpoints = ["Microsoft.Storage", "Microsoft.KeyVault"]
      }
      data = {
        address_prefix    = "10.1.2.0/24"
        service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
      }
    }
  }

  development = {
    address_space = ["10.2.0.0/16"]
    subnets = {
      dev-subnet = {
        address_prefix    = "10.2.1.0/24"
        service_endpoints = ["Microsoft.Storage"]
      }
    }
  }
}

enable_vpn_gateway         = false
enable_bastion             = false
on_premises_address_spaces = ["192.168.0.0/16"]

tags = {
  cost_centre = "platform-PLN14000"
  project     = "network-infrastructure"
}
