data "azurerm_subnet" "this" {
  for_each = var.aks_clusters

  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.resource_group_name
}
resource "azurerm_kubernetes_cluster" "this" {
  for_each = var.aks_clusters

  name                = each.value.aks_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  dns_prefix          = each.value.dns_prefix
  #kubernetes_version  = each.value.kubernetes_version

  default_node_pool {
    name                = each.value.node_pool.name
    vm_size             = each.value.node_pool.vm_size
    node_count          = each.value.node_pool.node_count
    min_count           = each.value.node_pool.min_count
    max_count           = each.value.node_pool.max_count
    max_pods            = each.value.node_pool.max_pods
    os_disk_size_gb     = each.value.node_pool.os_disk_size_gb
    vnet_subnet_id      = data.azurerm_subnet.this[each.key].id
    #enable_auto_scaling = false
    type                = "VirtualMachineScaleSets"
  }

  identity {
    type = each.value.identity_type
  }

  network_profile {
    network_plugin = "azure"
    network_policy = "azure"
    load_balancer_sku = "standard"
  }

  tags = each.value.tags
}
