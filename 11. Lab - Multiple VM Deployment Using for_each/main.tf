provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg1" {
  name     = var.rgname
  location = var.rglocation
}

resource "azurerm_virtual_network" "vnet1" {
  name                = var.vnetname
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = var.addressspace1
}



resource "azurerm_subnet" "subnets" {
  name                 = var.subnetname1
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = var.addresprefix1
}

resource "azurerm_network_interface" "nic1" {
  for_each            = toset(var.vm_names)
  name                = "${each.value}-nic"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnets.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_security_group" "nsg1" {
  for_each            = toset(var.vm_names)
  name                = "${each.value}-nsg"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  dynamic "security_rule" {
    for_each = var.security_rule
    iterator = rule
    content {
    name                       = rule.value.name
    priority                   = rule.value.priority
    direction                  = rule.value.direction
    access                     = rule.value.access
    protocol                   = rule.value.protocol
    source_port_range          = rule.value.source_port_range
    destination_port_range     = rule.value.destination_port_range
    source_address_prefix      = rule.value.source_address_prefix
    destination_address_prefix = rule.value.destination_address_prefix
  }
}
}

resource "azurerm_network_interface_security_group_association" "association1" {
  for_each                  = toset(var.vm_names)
  network_interface_id      = azurerm_network_interface.nic1[each.value].id
  network_security_group_id = azurerm_network_security_group.nsg1[each.value].id
}

resource "azurerm_windows_virtual_machine" "example" {
  for_each            = toset(var.vm_names)
  name                = each.value
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
  size                = var.machinetype
  admin_username      = var.userid
  admin_password      = var.passcode
  network_interface_ids = [
    azurerm_network_interface.nic1[each.value].id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = var.mspublisher
    offer     = var.msoffer
    sku       = var.mssku
    version   = var.msversion
  }
}
