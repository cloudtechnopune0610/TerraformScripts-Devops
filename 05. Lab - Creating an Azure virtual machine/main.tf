terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.93.0"
    }
  }
}

provider "azurerm" {
    subscription_id = "687576b5-cfc7-4d84-a216-afe39d6e983e"
client_id       = "1fe5640c-f447-48fb-88f3-1614b4e930c2"
client_secret   = "B~-8Q~ChRVmGPDgSpDBIFoxXdJy~UZbi4XmBbcmA"
tenant_id       = "82378404-048f-494e-82a9-407fb906df6d"
  features {}
}


locals {
  resource_group="DC900"
  location="West US 3"
}

resource "azurerm_resource_group" "RG1"{
  name=local.resource_group
  location=local.location
}


#data "azurerm_subnet" "SubnetA" {
 # name                 = "SubnetA"
  #virtual_network_name = "app-network"
  #resource_group_name  = local.resource_group
#}


resource "azurerm_virtual_network" "VNET1" {
  name                = "FE-VNET"
  address_space       = ["172.30.0.0/16"]
  location            = local.location
  resource_group_name = azurerm_resource_group.RG1.name
}

resource "azurerm_subnet" "Subnet1" {
  name                 = "MGMT"
  resource_group_name  = azurerm_resource_group.RG1.name
  virtual_network_name = azurerm_virtual_network.VNET1.name
  address_prefixes     = ["172.30.1.0/24"]
}


resource "azurerm_network_interface" "NIC1" {
  name                = "TS-NIC"
  location            = local.location
  resource_group_name = local.resource_group

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Subnet1.id
    private_ip_address_allocation = "Dynamic"
  }

  depends_on = [
    azurerm_virtual_network.VNET1
  ]
}

resource "azurerm_windows_virtual_machine" "VM1" {
  name                = "TS"
  resource_group_name = local.resource_group
  location            = local.location
  size                = "Standard_B2mS"
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

  
  


