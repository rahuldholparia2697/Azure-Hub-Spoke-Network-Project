#-------------------------------------------------------------
# Module: bastion
# Conditionally deploys an Azure Bastion (Standard SKU)
# with tunneling and file-copy capabilities enabled.
#-------------------------------------------------------------

resource "azurerm_public_ip" "bastion" {
  count = var.enable_bastion ? 1 : 0

  name                = "pip-bastion-hub"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = ["1", "2", "3"]
  tags                = var.tags
}

resource "azurerm_bastion_host" "bastion_instance" {
  count = var.enable_bastion ? 1 : 0

  name                = "bastion-hub"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Standard"

  copy_paste_enabled     = true
  file_copy_enabled      = true
  ip_connect_enabled     = true
  shareable_link_enabled = false
  tunneling_enabled      = true

  ip_configuration {
    name                 = "bastion-ipconfig"
    subnet_id            = var.bastion_subnet_id
    public_ip_address_id = azurerm_public_ip.bastion[0].id
  }

  tags = var.tags
}
