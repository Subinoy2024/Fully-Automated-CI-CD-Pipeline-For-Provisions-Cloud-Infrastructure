data "azurerm_subnet" "this" {
  for_each = var.vms

  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.rg_name
}
resource "azurerm_network_interface" "this" {
  for_each = var.vms

  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.rg_name

  ip_configuration {
    name                          = "primary"
    subnet_id                     = data.azurerm_subnet.this[each.key].id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = each.value.pip_id
  }

  tags = each.value.tags
}
resource "azurerm_linux_virtual_machine" "this" {
  for_each = var.vms

  name                = each.value.vm_name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  size                = each.value.size

  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.this[each.key].id
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = each.value.source_image_reference.publisher
    offer     = each.value.source_image_reference.offer
    sku       = each.value.source_image_reference.sku
    version   = each.value.source_image_reference.version
  }

  tags = each.value.tags
}
