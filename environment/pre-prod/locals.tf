locals {
  common_tags = {
    Environment = var.environment
    Owner       = "CloudOps"
    ManagedBy   = "Terraform"
  }

  resource_groups = {
    "rg-${var.environment}-core" = {
      location = var.location
      tags     = local.common_tags
    }
  }
  key_vault = {
    "kv-${var.environment}-core" = {
      location                    = var.location
      resource_group_name         = "rg-${var.environment}-core"
      name                        = "kv-${var.environment}-core"
      enabled_for_disk_encryption = true

    }
  }
  # secret = {
  #   "sec0${var.environment}dbadmin" = {
  #     name  = "sql_admin_username"
  #     value = var.sql_admin_username

  #   }
  #   "sec1${var.environment}vmpassword" = {
  #     name  = "vm_admin_password"
  #     value = var.vm_admin_password
  #   }
  #   "sec2${var.environment}vmadmin" = {
  #     name  = "vm_admin_username"
  #     value = var.vm_admin_username
  #   }
  #   "sec3${var.environment}sqlpassword" = {
  #     name  = "sql-admin-password"
  #     value = var.sql_admin_password

  #   }
  # }
  azurerm_key_vault_secret = {
    "vm-admin-username" = {
      value = var.vm_admin_username
    }

    "vm-admin-password" = {
      value = var.vm_admin_password
    }

    "sql-admin-password" = {
      value = var.sql_admin_password
    }
  }

  vnets = {
    "vnet-${var.environment}-core" = {
      resource_group_name = "rg-${var.environment}-core"
      location            = var.location
      address_space       = ["10.10.0.0/16"]
      tags                = local.common_tags
    }
  }

  subnets = {
    "snet-${var.environment}-app" = {
      resource_group_name  = "rg-${var.environment}-core"
      virtual_network_name = "vnet-${var.environment}-core"
      address_prefixes     = ["10.10.1.0/24"]

      service_endpoints = ["Microsoft.Storage"]
    }

    "snet-${var.environment}-pe" = {
      resource_group_name  = "rg-${var.environment}-core"
      virtual_network_name = "vnet-${var.environment}-core"
      address_prefixes     = ["10.10.2.0/24"]

      service_endpoints = []
    }
    "AzureBastionSubnet" = {
      resource_group_name  = "rg-${var.environment}-core"
      virtual_network_name = "vnet-${var.environment}-core"
      address_prefixes     = ["10.10.3.0/26"] # MUST be /26 or larger
      service_endpoints    = []
    }
  }
  nsgs = {
    "nsg-${var.environment}-app" = {
      location            = var.location
      resource_group_name = "rg-${var.environment}-core"
      tags                = local.common_tags
    }
  }

  nsg_rules = {
    "nsg-${var.environment}-app-allow-ssh" = {
      nsg_name                   = "nsg-${var.environment}-app"
      rule_name                  = "allow-ssh"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      resource_group_name        = "rg-${var.environment}-core"
    }

    "nsg-${var.environment}-app-allow-http" = {
      nsg_name                   = "nsg-${var.environment}-app"
      rule_name                  = "allow-http"
      priority                   = 200
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
      resource_group_name        = "rg-${var.environment}-core"
    }
  }
  public_ips = {
    "pip-${var.environment}-bastion" = {
      location            = var.location
      resource_group_name = "rg-${var.environment}-core"
      allocation_method   = "Static"
      sku                 = "Standard"
      tags                = local.common_tags
    }
    "pip-${var.environment}-vm01" = {
      location            = var.location
      resource_group_name = "rg-${var.environment}-core"
      allocation_method   = "Static"
      sku                 = "Standard"
      tags                = local.common_tags
    }
    "pip-${var.environment}-lb" = {
      location            = var.location
      resource_group_name = "rg-${var.environment}-core"
      allocation_method   = "Static"
      sku                 = "Standard"
      tags                = local.common_tags
    }
    "pip-${var.environment}-vm02" = {
      location            = var.location
      resource_group_name = "rg-${var.environment}-core"
      allocation_method   = "Static"
      sku                 = "Standard"
      tags                = local.common_tags
    }

  }
  subnet_nsg_associations = {
    "app-subnet-to-app-nsg" = {
      subnet_id = module.subnets.ids["snet-${var.environment}-app"]
      nsg_id    = module.nsgs.ids["nsg-${var.environment}-app"]
    }
  }
  vms = {
    "app01" = {
      location = var.location
      rg_name  = "rg-${var.environment}-core"

      vnet_name   = "vnet-${var.environment}-core"
      subnet_name = "snet-${var.environment}-app"

      nic_name = "nic-${var.environment}-app01"
      pip_id   = module.public_ips.ids["pip-${var.environment}-vm01"]

      vm_name = "vm-${var.environment}-app01"
      size    = "Standard_B2s"

      admin_username = var.vm_admin_username
      admin_password = var.vm_admin_password

      source_image_reference = {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
      }

      tags = local.common_tags
    }
    "app02" = {
      location = var.location
      rg_name  = "rg-${var.environment}-core"

      vnet_name   = "vnet-${var.environment}-core"
      subnet_name = "snet-${var.environment}-app"

      nic_name = "nic-${var.environment}-app02"
      pip_id   = module.public_ips.ids["pip-${var.environment}-vm02"]

      vm_name = "vm-${var.environment}-app02"
      size    = "Standard_B2s"

      admin_username = var.vm_admin_username
      admin_password = var.vm_admin_password

      source_image_reference = {
        publisher = "Canonical"
        offer     = "0001-com-ubuntu-server-jammy"
        sku       = "22_04-lts"
        version   = "latest"
      }

      tags = local.common_tags
    }
  }
  aks_clusters = {
    "aks-${var.environment}-core" = {
      location            = var.location
      resource_group_name = "rg-${var.environment}-core"

      aks_name   = "aks-${var.environment}-core"
      dns_prefix = "aks-${var.environment}"
      #kubernetes_version = "1.27.9"


      vnet_name   = "vnet-${var.environment}-core"
      subnet_name = "snet-${var.environment}-app"

      node_pool = {
        name            = "system"
        vm_size         = "Standard_D2s_v3"
        node_count      = 2
        min_count       = null
        max_count       = null
        max_pods        = 30
        os_disk_size_gb = 50
      }

      identity_type = "SystemAssigned"

      tags = local.common_tags
    }
  }
  sql = {
    location            = var.location
    resource_group_name = "rg-${var.environment}-core"

    sql_server_name = "sql-${var.environment}-core-${random_string.sql_suffix.result}"

    administrator_login    = var.sql_admin_username
    administrator_password = var.sql_admin_password

    vnet_name   = "vnet-${var.environment}-core"
    subnet_name = "snet-${var.environment}-pe"

    databases = {
      appdb = {
        name        = "appdb"
        sku_name    = "Basic"
        max_size_gb = 2
      }
    }

    tags = local.common_tags
  }

  bastion = {
    location            = var.location
    resource_group_name = "rg-${var.environment}-core"

    bastion_name = "bastion-${var.environment}"
    vnet_name    = "vnet-${var.environment}-core"

    # Must exist already as AzureBastionSubnet
    subnet_name = "AzureBastionSubnet"

    public_ip_id = module.public_ips.ids["pip-${var.environment}-bastion"]

    sku  = "Standard"
    tags = local.common_tags
  }
  load_balancers = {

    "app-lb" = {
      name                = "lb-dev-app"
      location            = var.location
      resource_group_name = "rg-${var.environment}-core"
      sku                 = "Standard"

      frontend_ip_configuration = {
        name                 = "frontend-ip"
        public_ip_address_id = module.public_ips.ids["pip-${var.environment}-lb"]
      }

      backend_pool_name = "backend-pool"

      probe = {
        name     = "http-probe"
        port     = 80
        protocol = "Tcp"
      }

      rule = {
        name                    = "http-rule"
        protocol                = "Tcp"
        frontend_port           = 80
        backend_port            = 80
        idle_timeout_in_minutes = 4
        enable_floating_ip      = false
      }

      tags = local.common_tags
    }

  }
  lb_backend_associations = {
    "appvm1" = {
      nic_id           = module.linux_vms.nic_ids["app01"]
      ip_configuration = "primary"
      backend_pool_id  = module.load_balancers.backend_pool_ids["app-lb"]
    }

    "appvm2" = {
      nic_id           = module.linux_vms.nic_ids["app02"]
      ip_configuration = "primary"
      backend_pool_id  = module.load_balancers.backend_pool_ids["app-lb"]
    }
  }
  log_analytics_workspaces = {
    core = {
      name                = "law-${var.environment}-core"
      location            = var.location
      resource_group_name = "rg-${var.environment}-core"
      retention_in_days   = 30
      sku                 = "PerGB2018"
      tags                = local.common_tags
    }
  }

}
/*

  diagnostic_settings = {
    vnet = {
      name                       = "diag-vnet"
      target_resource_id         = module.vnets.ids["vnet-${var.environment}-core"]
      log_analytics_workspace_id = module.monitoring.log_analytics_workspace_ids["core"]

      logs = [
        {
          category = "VMProtectionAlerts"
          enabled  = true
        }
      ]

      metrics = [
        {
          category = "AllMetrics"
          enabled  = true
        }
      ]
    }

    lb = {
      name                       = "diag-lb"
      target_resource_id         = module.load_balancers.lb_ids["app-lb"]
      log_analytics_workspace_id = module.monitoring.log_analytics_workspace_ids["core"]

      logs = [
        {
          category = "LoadBalancerAlertEvent"
          enabled  = true
        }
      ]

      metrics = [
        {
          category = "AllMetrics"
          enabled  = true
        }
      ]
    }
  }

}
*/