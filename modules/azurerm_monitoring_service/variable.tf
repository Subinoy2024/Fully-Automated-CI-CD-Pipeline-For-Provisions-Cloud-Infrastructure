variable "log_analytics_workspaces" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku                 = optional(string, "PerGB2018")
    retention_in_days   = optional(number, 30)
    tags                = map(string)
  }))
}


variable "diagnostic_settings" {
  type = map(object({
    name                       = string
    target_resource_id         = string
    log_analytics_workspace_id = string

    logs = list(object({
      category = string
    }))

    metrics = list(object({
      category = string
    }))
  }))
}
