terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.56"
    }
  }

  backend "azurerm" {
    resource_group_name  = "Azure-DevOps-RG"
    storage_account_name = "devstorageaccount2026"
    container_name       = "githubhubandspokecontainer"
    key                  = "terraform.tfstate"

    # Tells the backend to also use the Managed Identity
    use_msi = true
}

provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
}