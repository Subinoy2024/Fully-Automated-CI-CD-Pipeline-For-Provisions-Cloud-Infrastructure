resource "azurerm_recovery_services_vault" "this" {
  name                = var.name
  location            = var.location
  resource_group_name = var.rg_name
  sku                 = "Standard"
}
