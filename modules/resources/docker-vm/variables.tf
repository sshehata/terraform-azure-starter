# general purpose 4cores 16GB
variable "vm_size" {
  type        = string
  description = "type of hardware machine (default: Standard_B4ms)"
  default     = "Standard_B4ms"
}

variable "name" {
  type        = string
  description = "name of the server"
}

variable "resource_group" {
  type = object({
    name     = string
    location = string
  })
  description = "resource group to create vm in"
}

variable "vnet_name" {
  type        = string
  description = "virtual network to create vm in"
}

variable "environment" {
  type        = string
  description = "environment label (staging/production)"
}

variable "subnet_address_space" {
  type        = list(string)
  description = "list subnet address prefixes to create the vm in"
}

variable "network_security_group_id" {
  type        = string
  description = "network security group to associate with the subnet"
}
