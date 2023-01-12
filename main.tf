provider "azurerm" {
    alias   = "vhub"
    features {}
}

module "caf" {
  source  = "aztfmod/caf/azurerm"
  version = "5.4.4"

  global_settings       = var.global_settings
  logged_user_objectId  = var.logged_user_objectId
  resource_groups       = var.resource_groups
  keyvaults             = var.keyvaults


  networking = {
    vnets               = var.vnets
    private_dns   = var.private_dns
  }
}