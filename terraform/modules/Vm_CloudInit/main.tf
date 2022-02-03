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

resource "vmss-cloudinit" {
  source                                 = "Azure/vmss-cloudinit/azurerm"
  resource_group_name                    = var.resource_group_name
  cloudconfig_file                       = var.path
  location                               = var.location
  vm_size                                = "Standard_DS2_v2"
  admin_username                         = "azureuser"
  admin_password                         = random_string.rand_passwd.result
  ssh_key                                = "~/.ssh/id_rsa.pub"
  nb_instance                            = 2
  vm_os_simple                           = "UbuntuServer"
  vnet_subnet_id                         = var.subnet_id
  load_balancer_backend_address_pool_ids = "${module.loadbalancer.azurerm_lb_backend_address_pool_id}"
}

output "vmss_id" {
  value = "${module.vmss-cloudinit.vmss_id}"
}