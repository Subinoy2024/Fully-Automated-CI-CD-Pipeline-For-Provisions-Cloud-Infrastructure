resource "azurerm_network_interface_backend_address_pool_association" "this" {
  for_each = var.associations

  network_interface_id    = each.value.nic_id
  ip_configuration_name   = each.value.ip_configuration
  backend_address_pool_id = each.value.backend_pool_id
}
