terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.93.0"
    }
  }
}

provider "azurerm" {
/*subscription_id = "687576b5-cfc7-4d84-a216-afe39d6e983e"
client_id       = "1fe5640c-f447-48fb-88f3-1614b4e930c2"
client_secret   = "B~-8Q~ChRVmGPDgSpDBIFoxXdJy~UZbi4XmBbcmA"
tenant_id       = "82378404-048f-494e-82a9-407fb906df6d" */
  features {}
}

# refer to a resource group
data "azurerm_resource_group" "RG1" {
  name = "DC900"
}

data "azurerm_subnet" "SubnetA" {
  name                 = "MGMT"
  virtual_network_name = "FE-VNET"
  resource_group_name  = "DC900"
}

resource "azurerm_public_ip" "PublicIP1" {
  name                = "AppServer-PIP"
  resource_group_name = "DC900"
  location            = "East US"
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "NIC1" {
  name                = "AppServer-NIC"
  location            = "East US"
  resource_group_name = "DC900"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.SubnetA.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.PublicIP1.id
  }
 depends_on = [
    
    azurerm_public_ip.PublicIP1
  ]

}



resource "azurerm_windows_virtual_machine" "app_vm" {
  name                = "AppServer"
  resource_group_name = "DC900"
  location            = "East US"
  size                = "Standard_B2S"
  admin_username      = "admin100"
  admin_password      = "Passw0rd@12345"
  network_interface_ids = [
    azurerm_network_interface.NIC1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  
}

  

resource "azurerm_managed_disk" "data_disk" {
  name                 = "AppServer-DataDisk1"
  location             = "East US"
  resource_group_name  = "DC900"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 16
}
# Then we need to attach the data disk to the Azure virtual machine
resource "azurerm_virtual_machine_data_disk_attachment" "disk_attach" {
  managed_disk_id    = azurerm_managed_disk.data_disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.app_vm.id
  lun                = "0"
  caching            = "ReadWrite"
  depends_on = [
    azurerm_windows_virtual_machine.app_vm,
    azurerm_managed_disk.data_disk
  ]

 
}
