resource "azurerm_resource_group" "test" {
  #count = 2
  name      = "Testing"
  location  = "West US"
  #name      = element(var.resource_group_name, count.index)
  #location  = var.resource_group_location
}

resource "azurerm_virtual_network" "test" {
   name                = "Test-Vnet"
   address_space       = ["10.0.0.0/16"]
   location            = azurerm_resource_group.test.location
   resource_group_name = azurerm_resource_group.test.name
 }
 resource "azurerm_subnet" "test" {
   name                 = "dev1"
   resource_group_name  = azurerm_resource_group.test.name
   virtual_network_name = azurerm_virtual_network.test.name
   address_prefixes     = ["10.0.0.0/24"]
 }

 resource "azurerm_public_ip" "test" {
  count = 2
   name                        = "myip${format("%02d", count.index)}"
   location                     = azurerm_resource_group.test.location
   resource_group_name          = azurerm_resource_group.test.name
   allocation_method            = "Static"
   sku                          = "Basic"
 }

 resource "azurerm_network_interface" "test" {
count = 2
name = "testnic${format("%02d", count.index)}"
location = azurerm_resource_group.test.location
resource_group_name = azurerm_resource_group.test.name
ip_configuration {
name = "internal"
subnet_id = azurerm_subnet.test.id
private_ip_address_allocation = "Dynamic"
public_ip_address_id = element(azurerm_public_ip.test.*.id, count.index)
#public_ip_address_id = azurerm_public_ip.test_ip.id
#public_ip_address_id = azurerm_public_ip.example_public_ip.id
}
}

resource "azurerm_network_security_group" "test" {

count = 2
name = "testnsg${format("%02d", count.index)}"
location = azurerm_resource_group.test.location
resource_group_name = azurerm_resource_group.test.name

security_rule {
name = "RDP"
priority = 100
direction = "Inbound"
access = "Allow"
protocol = "Tcp"
source_port_range = "*"
destination_port_range = "3389"
source_address_prefix = "*"
destination_address_prefix = "*"
}
}

resource "azurerm_network_interface_security_group_association" "example" {
count = 2
#network_interface_id      = element(azurerm_network_interface.test.*.id, count.index)
#subnet_id = azurerm_subnet.test.id
network_security_group_id = "${azurerm_network_security_group.test.*.id[count.index]}"
network_interface_id      = "${azurerm_network_interface.test.*.id[count.index]}"
#managed_disk_id    = "${azurerm_managed_disk.test.*.id[count.index]}"

}

resource "azurerm_availability_set" "test" {
   name                         = "avset"
   location                     = azurerm_resource_group.test.location
   resource_group_name          = azurerm_resource_group.test.name
   platform_fault_domain_count  = 2
   platform_update_domain_count = 2
   managed                      = true
 }

 resource "azurerm_managed_disk" "test" {
   count                = 2
   name                 = "datadisk${format("%02d", count.index)}"
   location             = azurerm_resource_group.test.location
   resource_group_name  = azurerm_resource_group.test.name
   storage_account_type = "Standard_LRS"
   create_option        = "Empty"
   disk_size_gb         = "128"
 }

 resource "azurerm_virtual_machine" "test" {
   count                 = 2
   name                  = "VM${format("%02d", count.index)}"
   location              = azurerm_resource_group.test.location
   availability_set_id   = azurerm_availability_set.test.id
   resource_group_name   = azurerm_resource_group.test.name
   #network_interface_ids = [element(azurerm_network_interface.test.*.id, count.index)]
   network_interface_ids = [azurerm_network_interface.test.*.id[count.index],]
   vm_size               = "Standard_B2s"
   #admin_username      = "adminuser"
   #admin_password      = "Wind0wsazure"

storage_image_reference {
     publisher = "MicrosoftWindowsServer"
     offer     = "WindowsServer"
     sku       = "2016-Datacenter"
     version   = "latest"
   }

   
storage_os_disk {
    name = "vmosdisk${format("%02d", count.index)}"
    caching              = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
   }

   os_profile {
    computer_name  = "hostname"
    admin_username = "azureuser"
    admin_password = "Wind0wsazure"

 }
 os_profile_windows_config {
    provision_vm_agent = true
  }
 }

 resource "azurerm_virtual_machine_data_disk_attachment" "test" {
  count = 2
  #managed_disk_id    = azurerm_managed_disk.test[count.index]
  #virtual_machine_id = azurerm_virtual_machine.test[count.index]
  managed_disk_id    = "${azurerm_managed_disk.test.*.id[count.index]}"
  virtual_machine_id = "${azurerm_virtual_machine.test.*.id[count.index]}"
  lun = "${10+count.index}"
  caching            = "ReadWrite"
}