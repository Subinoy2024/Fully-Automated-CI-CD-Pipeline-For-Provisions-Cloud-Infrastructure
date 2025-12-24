output "sql_server_id" {
  description = "SQL Server ID"
  value       = azurerm_mssql_server.this.id
}

output "sql_server_name" {
  description = "SQL Server name"
  value       = azurerm_mssql_server.this.name
}

output "database_ids" {
  description = "Database IDs"
  value = {
    for k, db in azurerm_mssql_database.this :
    k => db.id
  }
}
