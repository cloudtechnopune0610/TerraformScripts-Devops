# We first specify the terraform provider. 
# Terraform will use the provider to ensure that we can work with Microsoft Azure

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.92.0"
    }
  }
}

# Here we need to mention the Azure AD Application Object credentials to allow us to work with 
# our Azure account

provider "azurerm" {
subscription_id = "687576b5-cfc7-4d84-a216-afe39d6e983e"
client_id       = "1fe5640c-f447-48fb-88f3-1614b4e930c2"
client_secret   = "B~-8Q~ChRVmGPDgSpDBIFoxXdJy~UZbi4XmBbcmA"
tenant_id       = "82378404-048f-494e-82a9-407fb906df6d"
  features {}
}

# The resource block defines the type of resource we want to work with
# The name and location are arguements for the resource block

data "azurerm_resource_group" "RG1"{
  name="DC90000" 
 # location="North Europe"
}

# Here we are creating a storage account.
# The storage account service has more properties and hence there are more arguements we can specify here

resource "azurerm_storage_account" "storage_account" {
  name                     = "cloudtechnopun90"
  resource_group_name      = data.azurerm_resource_group.RG1.name
  location                 = "North Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}