resource "azurerm_public_ip" "public_ip" {
  name                = "PublicIPForLB"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
}

resource "azurerm_lb" "lb" {
  name                = "TestLoadBalancer"
  location            = var.location
  resource_group_name = var.resource_group_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
}







































# resource "azurerm_lb" "lb" {
#   name                = "LoadBalancer"
#   resource_group_name = var.resource_group_name
#   location            = var.location
#   sku                 = "Standard"

#   frontend_ip_configuration {
#     name                          = "classiclb"
#     subnet_id                     = var.subnetid
#     private_ip_address_allocation = "Dynamic"
#   }
# }

# resource "azurerm_lb_backend_address_pool" "example" {
#   loadbalancer_id = azurerm_lb.lb.id
#   name            = "classiclb"
# }

# resource "azurerm_lb_probe" "example" {
#   resource_group_name = var.resource_group_name
#   loadbalancer_id     = azurerm_lb.lb.id
#   name                = "classiclb"
#   port                = 80
#   interval_in_seconds = 10
#   number_of_probes    = 3
#   protocol            = "Http"
#   request_path        = "/"
# }

# resource "azurerm_lb_rule" "example" {
#   resource_group_name            = var.resource_group_name
#   loadbalancer_id                = azurerm_lb.lb.id
#   name                           = "classiclb"
#   protocol                       = "Tcp"
#   frontend_port                  = 80
#   backend_port                   = 80
#   frontend_ip_configuration_name = "classiclb"
#   backend_address_pool_id        = azurerm_lb_backend_address_pool.example.id
#   probe_id                       = azurerm_lb_probe.example.id
# }