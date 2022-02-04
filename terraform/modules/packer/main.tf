resource "azurerm_subnet_network_security_group_association" "windows-vm-nsg-association" {
  subnet_id                 = var.subnet_id
  network_security_group_id = var.nsg_id
}

resource "azurerm_public_ip" "windows-vm-ip" {
  name                = "ip"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "windows-vm-nic" {
  name                = var.windows-vm-hostname
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows-vm-ip.id
  }

  tags = { 
    environment = "Dev"
  }
}

data "azurerm_image" "packer-image" {
  name                = "WindowsServer2019-Packer"
  resource_group_name = "kopicloud-packer-rg"
}

resource "azurerm_windows_virtual_machine" "windows-vm" {
  name                  = var.windows-vm-hostname
  location            = var.location
  resource_group_name = var.resource_group_name
  size                  = var.windows-vm-size
  network_interface_ids = [azurerm_network_interface.windows-vm-nic.id]
  
  computer_name         = var.windows-vm-hostname
  admin_username        = var.windows-admin-username
  admin_password        = var.windows-admin-password

  os_disk {
    name                 = "os-disk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_id = data.azurerm_image.packer-image.id
   
  enable_automatic_updates = true
  provision_vm_agent       = true

  tags = {
    environment = "Dev"
  }
}