locals {
  env = var.environment

  naming = {
    rg   = "rg-${local.env}-core"
    vnet = "vnet-${local.env}-core"
    snet = "snet-${local.env}-app"
    nsg  = "nsg-${local.env}-app"
    sa   = "st${local.env}core01"
    kv   = "kv-${local.env}-core"
    vm   = "vm-${local.env}-app01"
  }

  tags = merge(
    local.common_tags,
    {
      Environment = local.env
    }
  )
}
