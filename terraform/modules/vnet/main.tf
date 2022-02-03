resource "azurerm_network_security_group" "nsg" {
  name                = "network-security-group"
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_virtual_network" "vnet" {
  name                = "virtual-network"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  tags = {
    environment = "Dev"
  }
}

resource "azurerm_subnet" "subnet" {
    name = "subnet-test"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.vnet.name
}

output "subnetid" {
  value = azurerm_subnet.subnet.id
}