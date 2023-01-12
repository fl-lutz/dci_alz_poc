global_settings = {
  default_region = "gwc"
  regions = {
    gwc = "germanywestcentral"
  }
  resource_defaults = {
  }
}

resource_groups = {
  keyvaults_rg = {
    name = "alz-poc-security"
    tags = {
      workload = "alz-poc"
      ContactEmailAddress = "simon.dittlmann@zeiss.com"
    }
  }
  networking_rg = {
    name = "alz-poc-network"
    tags = {
      workload = "alz-poc"
      ContactEmailAddress = "simon.dittlmann@zeiss.com"
    }
  }
}

keyvaults = {
  secrets_keyvault = {
    name                          = "alzPocKv"
    resource_group_key            = "keyvaults_rg"
    sku_name                      = "standard"
    soft_delete_enabled           = false
    purge_protection_enabled      = false
    enabled_for_disk_encryption   = false
    # network = {
    #   bypass         = "None"
    #   default_action = "Deny"
    #   subnets = {
    #     subnet1 = {
    #       vnet_key   = "vnet_gwc"
    #       subnet_key = "default"
    #     }
    #   }
    # }
    tags = {
      workload = "alz-poc"
      ContactEmailAddress = "simon.dittlmann@zeiss.com"
    }
    creation_policies = {
      logged_in_user = {
        secret_permissions = ["Set", "Get", "List", "Delete", "Purge", "Recover"]
      }
    }

    private_endpoints = {
        keyvault_pe1 = {
            name = "alzPocKv-pe"
            resource_group_key = "networking_rg"
            vnet_key = "vnet_gwc"
            subnet_key = "default"

            private_service_connection = {
                name = "alzPocKv-private-link"
                subresource_names = ["vault"]
            }

            private_dns = {
                zone_group_name = "keyvault-private-dns-zone"
                keys = ["keyvault_dns"]
            }
        }
    }
  }
}


vnets = {
  vnet_gwc = {
    resource_group_key = "networking_rg"
    vnet = {
      name          = "alz-poc-network"
      address_space = ["10.100.100.0/24"]
    }
    tags = {
      workload = "alz-poc"
      ContactEmailAddress = "simon.dittlmann@zeiss.com"
    }
    subnets = {
      default = {
        name = "default"
        cidr = ["10.100.100.0/29"]
        service_endpoints = ["Microsoft.KeyVault"]
      }
    }
  }
}


private_dns = {
  keyvault_dns = {
    name               = "privatelink.vaultcore.azure.net"
    resource_group_key = "networking_rg"

    vnet_links = {
      vnlk1 = {
        name = "alzPocKv-vnet-link"
        vnet_key = "vnet_gwc"
      }
    }
  }
}