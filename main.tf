# Create a resource group
resource "azurerm_resource_group" "network" {
  name     = "${var.my_resource_group_name}"
  location = "${var.my_resource_group_location}"
}
# Create a virtual network within the resource group
resource "azurerm_virtual_network" "network" {
  name                = "${var.vertual_network_name}"
  address_space       = ["${var.virtual_network_range}"]
  location            = "${azurerm_resource_group.network.location}"
  resource_group_name = "${azurerm_resource_group.network.name}"
}
  resource "azurerm_subnet" "network" {
    name                 = "${var.subnet_name_1}"
    resource_group_name  = "${azurerm_resource_group.network.name}"
    virtual_network_name = "${azurerm_virtual_network.network.name}"
    address_prefix       = "${var.subnet_range_1}"
    count = "2"
  }
 # resource "azurerm_subnet" "network" {
 #   name                 = "${var.subnet_name_2}"
  #  resource_group_name  = "${azurerm_resource_group.network.name}"
   # virtual_network_name = "${azurerm_virtual_network.network.name}"
   # address_prefix       = "${var.subnet_range_2}"
 # }
resource "azurerm_public_ip" "network" {
  name                         = "public-ip"
  location                     = "${var.my_resource_group_location}"
  resource_group_name          = "${azurerm_resource_group.network.name}"
  public_ip_address_allocation = "static"

  }
#load balancer 
resource "azurerm_lb" "network" {
  name                = "test-lb"
  location            = "${var.my_resource_group_location}"
  resource_group_name = "${azurerm_resource_group.network.name}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.network.id}"
  }

}

resource "azurerm_lb_backend_address_pool" "network" {
  resource_group_name = "${azurerm_resource_group.network.name}"
  loadbalancer_id     = "${azurerm_lb.network.id}"
  name                = "BackEndAddressPool"
}

resource "azurerm_lb_probe" "network" {
  resource_group_name = "${azurerm_resource_group.network.name}"
  loadbalancer_id     = "${azurerm_lb.network.id}"
  name                = "ssh-running-probe"
  port                = "80"
}

resource "azurerm_lb_rule" "lbnatrule" {
    resource_group_name            = "${azurerm_resource_group.network.name}"
    loadbalancer_id                = "${azurerm_lb.network.id}"
    name                           = "http"
    protocol                       = "Tcp"
    frontend_port                  = "${var.application_port}"
    backend_port                   = "${var.application_port}"
    backend_address_pool_id        = "${azurerm_lb_backend_address_pool.network.id}"
    frontend_ip_configuration_name = "PublicIPAddress"
    probe_id                       = "${azurerm_lb_probe.network.id}"
}


