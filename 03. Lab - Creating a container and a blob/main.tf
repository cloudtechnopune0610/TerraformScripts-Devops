terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.92.0"
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
  name="DC900" 
  location="North Europe"
}

# Here we are creating a storage account.
# The storage account service has more properties and hence there are more arguements we can specify here

resource "azurerm_storage_account" "storage_account" {
  name                     = "cloudtechnopune90"
  resource_group_name      = "DC900"
  location                 = "North Europe"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  allow_blob_public_access = true
}

# Here we are creating a container in the storage account
resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = "cloudtechnopune90"
  container_access_type = "private"
  depends_on=[azurerm_storage_account.storage_account]
}

# This is used to upload a local file onto the container
#resource "azurerm_storage_blob" "sample" {
 # name                   = "sample.txt"
  #storage_account_name   = "appstore4577687"
  #storage_container_name = "data"
  #type                   = "Block"
  #source                 = "sample.txt"
#}
