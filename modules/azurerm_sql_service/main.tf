data "azurerm_subnet" "this" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_group_name
}
resource "azurerm_mssql_server" "this" {
  name                         = var.sql_server_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  version                      = var.sql_version
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_password

  tags = var.tags
}
resource "azurerm_mssql_database" "this" {
  for_each = var.databases

  name        = each.value.name
  server_id  = azurerm_mssql_server.this.id
  sku_name   = each.value.sku_name
  max_size_gb = each.value.max_size_gb
  depends_on = [
  azurerm_mssql_server.this
]

}
