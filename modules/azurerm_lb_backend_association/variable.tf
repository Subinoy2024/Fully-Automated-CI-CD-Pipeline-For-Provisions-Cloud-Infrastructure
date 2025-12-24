variable "associations" {
  description = "NIC to Load Balancer backend pool associations"
  type = map(object({
    nic_id              = string
    ip_configuration    = string
    backend_pool_id     = string
  }))
}
