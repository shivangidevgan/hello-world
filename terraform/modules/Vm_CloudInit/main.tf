resource "random_string" "rand_passwd" {
  length = 15
  special = true
  lower = true
  upper = true
  number = true
  min_numeric = 3
  min_special = 3
  override_special = "&!$"
}

resource "azurerm_resource_group" "cloudinit" {
  name     = "cloudinit-resources"
  location = var.location
}

resource "azurerm_virtual_network" "cloudinit" {
  name                = "cloudinit-network"
  address_space       = ["10.0.0.0/16"]
  location = var.location
  resource_group_name = var.resource_group_name 
}

resource "azurerm_subnet" "cloudinit" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.cloudinit.name
  virtual_network_name = azurerm_virtual_network.cloudinit.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "cloudinit" {
  name                = "cloudinit-pip"
  location = var.location
  resource_group_name = var.resource_group_name 
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "cloudinit" {
  name                = "cloudinit-sg"
  location = var.location
  resource_group_name = var.resource_group_name 

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "cloudinit" {
  name                = "cloudinit-nic"
  location = var.location
  resource_group_name = var.resource_group_name 

  ip_configuration {
    name                          = "cloudinit-nic-config"
    subnet_id                     = azurerm_subnet.cloudinit.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.cloudinit.id
  }
}

resource "azurerm_network_interface_security_group_association" "cloudinit" {
  network_interface_id      = azurerm_network_interface.cloudinit.id
  network_security_group_id = azurerm_network_security_group.cloudinit.id
}

resource "azurerm_linux_virtual_machine" "cloudinit" {
  name                = "cloudinit-machine"
  resource_group_name = var.resource_group_name 
 location = var.location
  size                = "Standard_B2ms"
  admin_username      = var.username
  admin_password      = random_string.rand_passwd.result
  custom_data = "%SYSTEMDRIVE%/AzureData/CustomData.bin"

  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.cloudinit.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

output "public_ip" {
  value = azurerm_linux_virtual_machine.cloudinit.public_ip_address
}