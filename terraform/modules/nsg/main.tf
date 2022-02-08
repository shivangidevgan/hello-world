locals {
  prefix = var.username
}

resource "azurerm_network_security_group" "azurensg" {
    name = join("-",[local.prefix,"nsg"])
    location = var.location
    resource_group_name = var.resource_group_name

    security_rule {
        name = "AllowHttp"
        priority = 300
        direction = "Inbound"
        access = "Allow"
        protocol = "Tcp"
        source_port_range = "*"
        destination_port_range = 3389
        source_address_prefix = "*"
        destination_address_prefix = "*"
    }
    tags = {
       environment="Dev"
  }
}