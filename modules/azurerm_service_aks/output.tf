output "ids" {
  description = "AKS cluster IDs"
  value = {
    for k, aks in azurerm_kubernetes_cluster.this :
    k => aks.id
  }
}

output "names" {
  description = "AKS cluster names"
  value = {
    for k, aks in azurerm_kubernetes_cluster.this :
    k => aks.name
  }
}

output "kube_configs" {
  description = "Raw kubeconfig"
  value = {
    for k, aks in azurerm_kubernetes_cluster.this :
    k => aks.kube_config_raw
  }
  sensitive = true
}
