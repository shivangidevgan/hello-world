module "acr" {
  source = "./modules/acr"
  resource_group_name = var.resource_group_name
  location = var.location
}

module "nsg" {
  source = "./modules/nsg"
  resource_group_name = var.resource_group_name
  location = var.location
  username = var.username
}

# module "storage_acc" {
#   source = "./modules/storage_acc"
#   resource_group_name = var.resource_group_name
#   location = var.location
#   username = var.username
# }

module "vnet"{
  source = "./modules/vnet"
  resource_group_name = var.resource_group_name
  location = var.location
}

module "vm" {
  source = "./modules/vm"
  resource_group_name = var.resource_group_name
  location = var.location
  username = var.username
  subnetid = module.vnet.subnetid
}

module "loadbalancer"{
  source = "./modules/loadbalancer"
  resource_group_name = var.resource_group_name
  location = var.location
}

module "web_app_server" {
  source = "./modules/web_app_server"
  vm_id = module.vm.vm_id
}

# module "vm_cloudinit" {
#   source = "./modules/vm_cloudinit"
#   resource_group_name = var.resource_group_name
#   location = var.location
# }