variable "my_resource_group_name" {
  default     = "my_resource_groupe"
  description = "Name tag for the resource group to be created"
}
variable "my_resource_group_location" {
  default     = "Central India"
  description = "Name tag for the resource group location   to be created"
}
variable "vertual_network_name" {
  default     = "my_vertual_network"
  description = "Name tag for the Virtual private network to be created"
}
variable "virtual_network_range" {
  default     = "10.0.0.0/16"
  description = "Name tag for range of the Virtual private network to be created"
}
variable "subnet_range_1" {
  default     = "10.0.1.0/24"
  description = "Name tag for range of the subnet first to be created"
}
variable "subnet_range_2" {
  default     = "10.0.2.0/24"
  description = "Name tag for range of the subnet second to be created"
}
variable "my_network_interface" {
  default     = "my_network_interface"
  description = "Name tag for network interface to be created"
}
variable "private_ip_address_allocation" {
  default     = "dynamic"
  description = "private_ip_address_allocation for machines"
}
variable "disk_size" {
  default     = "30"
  description = "disk size allocation for machine by default"
}
variable "VM_SIZE_ALOCATION" {
  default     = "Standard_D2S_V3 "
  description = "VM size allocation for machine by default"
}
variable "publisher_name" {
  default     = "Canonical "
  description = "VM size allocation for machine by default"
}
variable "offer_name" {
  default     = "UbuntuServer "
  description = "offer name for virtual machines"
}
variable "sku_name" {
  default     = "14.04-LTS "
  description = " virtual machines sku name"
}
