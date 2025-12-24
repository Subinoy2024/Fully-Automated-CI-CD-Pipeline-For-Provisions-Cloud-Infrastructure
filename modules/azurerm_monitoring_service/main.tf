resource "azurerm_log_analytics_workspace" "workspace" {
  for_each = var.log_analytics_workspaces

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku
  retention_in_days   = each.value.retention_in_days

  tags = each.value.tags
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic" {
  for_each = var.diagnostic_settings

  name                       = each.value.name
  target_resource_id         = each.value.target_resource_id
  log_analytics_workspace_id = each.value.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = each.value.logs
    content {
      category = enabled_log.value.category
    }
  }

  dynamic "enabled_metric" {
    for_each = each.value.metrics
    content {
      category = enabled_metric.value.category
    }
  }
}
