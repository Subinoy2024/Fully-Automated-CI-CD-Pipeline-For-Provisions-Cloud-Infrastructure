variable "aks_clusters" {
  description = "Map of AKS clusters"
  type = map(object({
    location            = string
    resource_group_name = string

    aks_name    = string
    dns_prefix = string
    #kubernetes_version = string

    vnet_name   = string
    subnet_name = string

    node_pool = object({
      name       = string
      vm_size    = string
      node_count = number
      min_count  = number
      max_count  = number
      max_pods   = number
      os_disk_size_gb = number
    })

    identity_type = string  # SystemAssigned

    tags = map(string)
  }))
}
