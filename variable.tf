# Resource group variables
variable "my_resource_group_name" {
  default     = "my_resource_groupe"
  description = "Name tag for the resource group to be created"
}
variable "my_resource_group_location" {
  default     = "Central India"
  description = "Name tag for the resource group location   to be created"
}
# virtual network variables
variable "vertual_network_name" {
  default     = "my_vertual_network"
  description = "Name tag for the Virtual private network to be created"
}
variable "virtual_network_range" {
  default     = "10.0.0.0/16"
  description = "Name tag for range of the Virtual private network to be created"
}
variable "subnet_name_1" {
  default     = "my_subnet_1"
  description = "Name tag for range of the subnet first to be created"
}
variable "subnet_range_1" {
  default     = "10.0.1.0/24"
  description = "Name tag for range of the subnet first to be created"
}
variable "subnet_name_2" {
  default     = "my_subnet_2"
  description = "Name tag for range of the subnet first to be created"
}
variable "subnet_range_2" {
  default     = "10.0.2.0/24"
  description = "Name tag for range of the subnet second to be created"
}
variable "application_port" {
    description = "The port that you want to expose to the external load balancer"
    default     = 80
}

variable "admin_password" {
    description = "Default password for admin"
    default = "Passwwoord11223344"
}
