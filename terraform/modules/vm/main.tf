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

resource "azurerm_public_ip" "public_ip" {
  name                   = "public_ip"
  location               = var.location
  resource_group_name    = var.resource_group_name
  allocation_method      = "Dynamic"
  
}

resource "azurerm_network_interface" "nic" {
  name                = "nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "testconfiguration"
    subnet_id                     = var.subnetid
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}

resource "azurerm_windows_virtual_machine" "azurevm" {
  name                            = "vm"
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = "Standard_B2ms"
  admin_username                  = var.username
  admin_password                  = random_string.rand_passwd.result
  network_interface_ids = [azurerm_network_interface.nic.id]

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }
}

#autoscale sets
resource "azurerm_windows_virtual_machine_scale_set" "vmss" {
  name                = "vmss"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard_B2ms"
  instances           = 1
  admin_password      = random_string.rand_passwd.result
  admin_username      = var.username

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter-Server-Core"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = azurerm_network_interface.nic.name
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.subnetid
    }
  }
}