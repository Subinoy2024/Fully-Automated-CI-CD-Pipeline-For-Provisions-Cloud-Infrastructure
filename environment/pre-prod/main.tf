module "resource_groups" {
  source          = "../../modules/azurerm_resource_group"
  resource_groups = local.resource_groups

}
resource "random_string" "sql_suffix" {
  length  = 4
  upper   = false
  special = false
  lower   = true
  numeric = true
}

module "vnets" {
  source     = "../../modules/azurerm_virtual_network"
  depends_on = [module.resource_groups]

  vnets = {
    for name, v in local.vnets :
    name => merge(

      v,
      {
        resource_group_name = module.resource_groups.names[v.resource_group_name]
      }
    )
  }
}


module "subnets" {
  depends_on = [module.vnets]
  source     = "../../modules/azurerm_subnet"
  subnets    = local.subnets
}

module "nsgs" {
  depends_on = [module.resource_groups, module.subnets, module.vnets]
  source     = "../../modules/azurerm_network_security_group"
  nsgs       = local.nsgs
  nsg_rules  = local.nsg_rules
}

module "nsg_associations" {
  depends_on = [module.vnets, module.subnets, module.nsgs]
  source     = "../../modules/azurerm_nsg_rules_association"

  subnet_nsg_associations = local.subnet_nsg_associations
}

module "public_ips" {
  depends_on = [module.vnets]
  source     = "../../modules/azurerm_public_internet"
  public_ips = local.public_ips
}

module "linux_vms" {
  depends_on = [module.resource_groups, module.vnets, module.subnets, module.nsgs, module.nsg_associations]
  source     = "../../modules/azurerm_virtual_machine"

  vms = local.vms
}

module "aks" {
  depends_on = [module.resource_groups, module.vnets, module.subnets, module.nsgs, module.nsg_associations]
  source     = "../../modules/azurerm_service_aks"

  aks_clusters = local.aks_clusters
}

module "sql" {
  depends_on = [module.subnets]
  source     = "../../modules/azurerm_sql_service"

  location               = local.sql.location
  resource_group_name    = local.sql.resource_group_name
  sql_server_name        = local.sql.sql_server_name
  administrator_login    = local.sql.administrator_login
  administrator_password = local.sql.administrator_password
  sql_version            = "12.0"

  vnet_name   = local.sql.vnet_name
  subnet_name = local.sql.subnet_name

  databases = local.sql.databases
  tags      = local.sql.tags
}

module "bastion" {
  depends_on = [module.subnets, module.vnets]
  source     = "../../modules/azurerm_bastion_service"

  location            = local.bastion.location
  resource_group_name = local.bastion.resource_group_name

  bastion_name = local.bastion.bastion_name
  vnet_name    = local.bastion.vnet_name
  subnet_name  = local.bastion.subnet_name

  public_ip_id = local.bastion.public_ip_id
  sku          = local.bastion.sku
  tags         = local.bastion.tags

}

module "key_vault" {
  source = "../../modules/azurerm_key_vault"

  name                = "kv-${var.environment}-core-${random_string.sql_suffix.result}"
  location            = var.location
  resource_group_name = "rg-${var.environment}-core"

  secrets = local.azurerm_key_vault_secret
  tags    = local.common_tags

  depends_on = [
    module.resource_groups, module.linux_vms, module.sql, module.vnets
  ]
}
module "load_balancers" {
  source = "../../modules/azurerm_loadbalancer"

  load_balancers = local.load_balancers

  depends_on = [
    module.public_ips
  ]
}

module "lb_backend_associations" {
  source = "../../modules/azurerm_lb_backend_association"

  associations = local.lb_backend_associations

  depends_on = [
    module.linux_vms,
    module.load_balancers
  ]
}
# module "monitoring" {
#   source = "../../modules/azurerm_monitoring_service"

#   log_analytics_workspaces = local.log_analytics_workspaces
#   diagnostic_settings      = local.diagnostic_settings

#   depends_on = [
#     module.vnets,
#     module.load_balancers,
#     module.resource_groups
#   ]
# }
