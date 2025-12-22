resource "azurerm_bastion_host" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name
  subnet_id           = var.subnet_id
  public_ip_address_id = var.public_ip_id
}
