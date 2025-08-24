terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.40.0"
    }
  }
}
provider "azurerm" {
  features {}
  subscription_id = "18f8e7c5-a3db-4324-b49d-7ef07eace03f"
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
