resource "azurerm_storage_account" "st11" {
    name                     = "rajatstorageacctrrr"
    resource_group_name      = azurerm_resource_group.example.name
    location                 = azurerm_resource_group.example.location
    account_tier             = "Standard"
    account_replication_type = "LRS"

    tags = {
        environment = "Dev"
    }
}