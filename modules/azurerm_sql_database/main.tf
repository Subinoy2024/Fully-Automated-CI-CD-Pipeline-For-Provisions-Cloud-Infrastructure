resource "azurerm_mssql_server" "this" {
  name                         = var.server_name
  resource_group_name          = var.rg_name
  location                     = var.location
  administrator_login          = var.admin_user
  administrator_login_password = var.admin_password
}

resource "azurerm_mssql_database" "this" {
  name      = var.db_name
  server_id = azurerm_mssql_server.this.id
  sku_name = "S0"
}
