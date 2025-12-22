module "resource_group" {
  source   = "../../modules/azurerm_resource_group"
  name     = local.naming.rg
  location = var.location
  tags     = local.tags
}

module "vnet" {
  source        = "../../modules/azurerm_virtual_network"
  name          = local.naming.vnet
  location      = var.location
  rg_name       = module.resource_group.name
  address_space = ["10.10.0.0/16"]
  tags          = local.tags
}

module "subnet" {
  source              = "../../modules/azurerm_subnet"
  name                = local.naming.snet
  rg_name             = module.resource_group.name
  vnet_name           = module.vnet.name
  address_prefixes    = ["10.10.1.0/24"]
}

module "nsg" {
  source   = "../../modules/azurerm_network_security_group"
  name     = local.naming.nsg
  location = var.location
  rg_name  = module.resource_group.name
  tags     = local.tags

  rules = {
    ssh = {
      priority  = 100
      direction = "Inbound"
      access    = "Allow"
      protocol  = "Tcp"
      port      = "22"
    }
  }
}

module "storage" {
  source   = "../../modules/azurerm_storage_account"
  name     = local.naming.sa
  location = var.location
  rg_name  = module.resource_group.name
  tags     = local.tags
}

module "keyvault" {
  source   = "../../modules/azurerm_key_vault"
  name     = local.naming.kv
  location = var.location
  rg_name  = module.resource_group.name
  tags     = local.tags
}
