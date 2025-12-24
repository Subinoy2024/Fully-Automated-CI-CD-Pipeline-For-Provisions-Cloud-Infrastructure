variable "vms" {
  description = "Map of Linux VMs"
  type = map(object({
    location    = string
    rg_name     = string

    vnet_name   = string
    subnet_name = string

    nic_name    = string
    pip_id      = string

    vm_name     = string
    size        = string

    admin_username = string
    admin_password = string

    source_image_reference = object({
      publisher = string
      offer     = string
      sku       = string
      version   = string
    })

    tags = map(string)
  }))
}
