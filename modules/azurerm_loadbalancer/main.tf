resource "azurerm_lb" "this" {
  for_each = var.load_balancers

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku

  frontend_ip_configuration {
    name                 = each.value.frontend_ip_configuration.name
    public_ip_address_id = each.value.frontend_ip_configuration.public_ip_address_id
  }

  tags = each.value.tags
}
resource "azurerm_lb_backend_address_pool" "this" {
  for_each = var.load_balancers

  name            = each.value.backend_pool_name
  loadbalancer_id = azurerm_lb.this[each.key].id
}
resource "azurerm_lb_probe" "this" {
  for_each = var.load_balancers

  name                = each.value.probe.name
  protocol            = each.value.probe.protocol
  port                = each.value.probe.port
  loadbalancer_id     = azurerm_lb.this[each.key].id
}
resource "azurerm_lb_rule" "this" {
  for_each = var.load_balancers

  name                           = each.value.rule.name
  protocol                       = each.value.rule.protocol
  frontend_port                  = each.value.rule.frontend_port
  backend_port                   = each.value.rule.backend_port
  idle_timeout_in_minutes        = each.value.rule.idle_timeout_in_minutes

  loadbalancer_id                = azurerm_lb.this[each.key].id
  frontend_ip_configuration_name = each.value.frontend_ip_configuration.name
  backend_address_pool_ids       = [
    azurerm_lb_backend_address_pool.this[each.key].id
  ]
  probe_id = azurerm_lb_probe.this[each.key].id
}
