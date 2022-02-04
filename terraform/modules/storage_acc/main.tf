resource "azurerm_storage_account" "stg" {
  name                     = "neusta1"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "container" {
  name                  = "statefiles"
  storage_account_name  = azurerm_storage_account.stg.name
  container_access_type = "private"
}