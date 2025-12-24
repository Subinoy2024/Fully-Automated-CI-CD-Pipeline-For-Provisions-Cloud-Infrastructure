output "log_analytics_workspace_ids" {
  value = {
    for k, v in azurerm_log_analytics_workspace.workspace :
    k => v.id
  }
}
