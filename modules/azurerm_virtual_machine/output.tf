output "vm_ids" {
  description = "VM IDs"
  value = {
    for k, vm in azurerm_linux_virtual_machine.this :
    k => vm.id
  }
}

output "nic_ids" {
  description = "NIC IDs"
  value = {
    for k, nic in azurerm_network_interface.this :
    k => nic.id
  }
}

output "private_ips" {
  description = "Private IP addresses"
  value = {
    for k, vm in azurerm_linux_virtual_machine.this :
    k => vm.private_ip_address
  }
}
