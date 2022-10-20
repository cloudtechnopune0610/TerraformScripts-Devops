resource "azurerm_resource_group" "rg1" {
  name = "${var.prefix}-rg"
  location = var.location
}

  resource "azurerm_virtual_network" "vnet1" {
  name                = "${var.prefix}-vnet"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  address_space       = var.addressspace1
}

resource "azurerm_subnet" "subnet1" {
  name                 = var.subnetname
  resource_group_name  = azurerm_resource_group.rg1.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = [var.address1]
depends_on = [
  azurerm_virtual_network.vnet1
]
}

resource "azurerm_network_interface" "nic" {
  count = var.machinecount
  name                = "${var.prefix}-nic${count.index+1}"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    
  }
  depends_on = [
    azurerm_virtual_network.vnet1
  ]
}

resource "azurerm_network_security_group" "nsg" {
  count = var.machinecount
  name                = "${var.prefix}-nsg${count.index+1}"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name

  security_rule {
    name                       = "test123"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
  depends_on = [
    azurerm_network_interface.nic
  ]
}

resource "azurerm_network_interface_security_group_association" "association" {
  count = var.machinecount
  network_interface_id      = element(azurerm_network_interface.nic.*.id, count.index)
  network_security_group_id = element(azurerm_network_security_group.nsg.*.id, count.index)
}

resource "azurerm_virtual_machine" "VM" {
  count = var.machinecount
  name                  = "${var.prefix}-appserver${count.index+1}"
  location              = azurerm_resource_group.rg1.location
  resource_group_name   = azurerm_resource_group.rg1.name
  network_interface_ids = [azurerm_network_interface.nic[count.index].id]
  vm_size               = var.vmtype

   storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.prefix}-osdisk${count.index+1}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.hostname}${count.index}"
    admin_username = "admin100"
    admin_password = "Passw0rd@12345"
  }
  os_profile_windows_config {
    provision_vm_agent = true
  }
}
