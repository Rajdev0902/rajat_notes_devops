terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "4.28.0"
    }
  }
}
provider "azurerm" {
    features {}
    subscription_id = "154417f6-bbf4-4148-933e-769e8824a185"
}

resource "azurerm_resource_group" "RG_tfRajat1" {
    count    =  length(var.rg_names)
    name     =  var.rg_names[count.index]
    location = "East US"
}
