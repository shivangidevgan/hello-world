locals {
  prefix = var.username
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  name                = "buildagent-vmss"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard_b2ms"
  instances           = var.numberOfWorkerNodes

  overprovision          = false
  single_placement_group = false

  admin_username      = "adminuser"
  admin_password      = azurerm_key_vault_secret.vmsecret.value

  disable_password_authentication = false

  custom_data = base64encode(data.local_file.cloudinit.content)

  source_image_reference {
    publisher = "canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadOnly"

    diff_disk_settings {
      option = "Local"
    }
  }

  network_interface {
    name    = join("-",[local.username,"vmss-nic"])
    primary = true

    ip_configuration {
      name      = join("-",[local.username,"vmss-ipconfig"])
      primary   = true
      subnet_id = azurerm_subnet.vmss.id
    }
  }

  boot_diagnostics {
    storage_account_uri = null
  }
}

data "local_file" "cloudinit" {
    filename = "${path.module}/cloudinit.conf"
}