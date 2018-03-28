provider "azurerm" { }

# Create a resource group
resource "azurerm_resource_group" "network" {
  name     = "${var.my_resource_group_name}"
  location = "${var.my_resource_group_location}"
}

# Create a virtual network within the resource group
resource "azurerm_virtual_network" "network" {
  name                = "${var.vertual_network_name}"
  address_space       = ["10.0.0.0/16"]
  location            = "${azurerm_resource_group.network.location}"
  resource_group_name = "${azurerm_resource_group.network.name}"
}
  resource "azurerm_subnet" "network" {
    name                 = "my_subnet_1"
    resource_group_name  = "${azurerm_resource_group.network.name}"
    virtual_network_name = "${azurerm_virtual_network.network.name}"
    address_prefix       = "${var.subnet_range_1}"
  }
  resource "azurerm_subnet" "network1" {
    name                 = "my subnet_2"
    resource_group_name  = "${azurerm_resource_group.network.name}"
    virtual_network_name = "${azurerm_virtual_network.network.name}"
    address_prefix       = "${var.subnet_range_2}"
  }
  resource "azurerm_network_interface" "network" {
  name                = "${var.my_network_interface}"
  location            = "${azurerm_resource_group.network.location}"
  resource_group_name = "${azurerm_resource_group.network.name}"

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = "${azurerm_subnet.network.id}"
    private_ip_address_allocation = "${var.private_ip_address_allocation}"
  }
}
resource "azurerm_managed_disk" "network" {
  name                 = "datadisk_existing"
  location             = "${azurerm_resource_group.network.location}"
  resource_group_name  = "${azurerm_resource_group.network.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "${var.disk_size}"
}
resource "azurerm_virtual_machine" "network" {
  name                  = "virtual_machine_name"
  location              = "${azurerm_resource_group.network.location}"
  resource_group_name   = "${azurerm_resource_group.network.name}"
  network_interface_ids = ["${azurerm_network_interface.network.id}"]
  vm_size               = "${var.VM_SIZE_ALOCATION}"

  storage_image_reference {
    publisher = "${var.publisher_name}"
    offer     = "${var.offer_name}"
    sku       = "${var.sku_name}"
    version   = "latest"

}
   storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
os_profile {
  computer_name  = "hostname"
  admin_username = "ubuntu"
  admin_password = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC6ZcIT9KWVwxhcqukevoGVLGH6CJbRgR/YeE/27I4VPzZTOc9fk3mZy5p/7mpzxXRHuvSNWlooFt0uqJnRmq4j8Al6lm0QKWl4YbXqU7eodCrcMv8WnBH3EXKEu/cx49Hc3uegNt7gd7ktSBRa/d6uSr02FmUMs+BMaOI3RspLSB+UL82pELqgf4o+UxauJ4sQFswrceF2fAmUHXfFjeuA5PMi0G6VedCrSAJej6R4InDaHBxEIaj2T/Kj1xJPvkTF7VnNO6lo407+eUqQ0CkS39Erq/DeYAQcvO3ZP0aiKG8OJ7ccx1k0i3gwDnNllYU9sOe/GTuh6nUQ0VJ12Vsd vivek@vivek-Latitude-3460"
}
}

