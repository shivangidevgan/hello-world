resource "cloud_network" "app_network" {
  name = "Application network"
  zone = var.zone 

  ip_network {
    address = "172.20.1.0/24"
    dhcp    = true
    family  = "IPv4"
  }
}

resource "cloud_network" "db_network" {
  name = "Database network"
  zone = var.zone 

  ip_network {
    address = "172.20.2.0/24"
    dhcp    = true
    family  = "IPv4"
  }
}

resource "cloud_server" "app" {
  zone     = var.zone 
  hostname = "app${count.index + 1}.startup.io"
  plan     = var.plans["app"] 
  count    = var.app-scaling 

  login {
    user = "root"
    keys = [
      var.public_key,
    ]
    create_password   = false
    password_delivery = "none"
  }

  template {
    size    = var.storages[var.plans["app"]]
    storage = var.template
  }

  network_interface {
    type    = "private"
    network = cloud_network.app_network.id
  }
  network_interface {
    type    = "private"
    network = cloud_network.db_network.id
  }
}