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



resource "azurerm_resource_group" "RG1"{
  name="FE-Infra"
  location="East US"
}

resource "azurerm_virtual_network" "VNET1" {
  name                = "FE-VNET"
  location            = "East US"
  resource_group_name = "FE-Infra"
  address_space       = ["172.30.0.0/16"]

  subnet {
    name           = "GatewaySubnet"
    address_prefix = "172.30.1.0/24"
    # depends_on=[azurerm_virtual_network.VNET1]
  }  
  subnet {
    name           = "AzureFirewallSubnet"
    address_prefix = "172.30.2.0/24"
    #security_group = azurerm_network_security_group.example.id
  }
}
