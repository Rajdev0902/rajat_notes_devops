terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.34.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "8f765261-0137-4fd7-b8de-53247b5236d0"
}

resource "azurerm_resource_group" "Rajatrg" {
  name     = "Rgfor_rajat"
  location = "westus"
}
resource "azurerm_storage_account" "stg" {
  depends_on              = [azurerm_resource_group.Rajatrg]
  name                    = "rajatstorageacct01"
  location                = azurerm_resource_group.Rajatrg.location
  resource_group_name     = azurerm_resource_group.Rajatrg.name
  account_tier            = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_storage_container" "container" {
  depends_on            = [azurerm_resource_group.Rajatrg, azurerm_storage_account.stg]
  name                  = "mycontainer"
  storage_account_id    = azurerm_storage_account.stg.id
  container_access_type = "private"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "rajat-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Rajatrg.location
  resource_group_name = azurerm_resource_group.Rajatrg.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "rajat-subnet"
  resource_group_name  = azurerm_resource_group.Rajatrg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "public_ip" {
  name                = "rajat-public-ip"
  location            = azurerm_resource_group.Rajatrg.location
  resource_group_name = azurerm_resource_group.Rajatrg.name
  allocation_method   = "Dynamic"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "nic" {
  name                = "rajat-nic"
  location            = azurerm_resource_group.Rajatrg.location
  resource_group_name = azurerm_resource_group.Rajatrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_key_vault" "kv" {
  name                        = "rajat-keyvault01"
  location                    = azurerm_resource_group.Rajatrg.location
  resource_group_name         = azurerm_resource_group.Rajatrg.name
  tenant_id                   = "YOUR_TENANT_ID" // Replace with your Azure AD tenant ID
  sku_name                    = "standard"
  soft_delete_retention_days  = 7
  enabled_for_disk_encryption = true    
  purge_protection_enabled    = false 

  access_policy {
    tenant_id = "3c8faa8b-263e-416d-bbb8-6eea957127df" 
    object_id = "YOUR_OBJECT_ID" 
    secret_permissions = [
      "get"
    ]
    key_permissions = [
      "get"
      
    ]
  }
}
