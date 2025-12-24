variable "load_balancers" {
  description = "Azure Load Balancers"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku                 = optional(string, "Standard")

    frontend_ip_configuration = object({
      name                 = string
      public_ip_address_id = string
    })

    backend_pool_name = string

    probe = object({
      name     = string
      port     = number
      protocol = string
    })

    rule = object({
      name                       = string
      protocol                   = string
      frontend_port              = number
      backend_port               = number
      idle_timeout_in_minutes    = number
      enable_floating_ip         = bool
    })

    tags = map(string)
  }))
}
