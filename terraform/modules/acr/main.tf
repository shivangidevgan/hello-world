resource "azurerm_resource_group" "rg" {
  name     = "Dev-RG"
  location = var.location
}

resource "azurerm_container_registry" "acr" {
  name                = "DevAppModACR"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard"
  admin_enabled       = false
}