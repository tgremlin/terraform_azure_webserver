variable "ARM_CLIENT_ID" {
    type = string
}
variable "ARM_CLIENT_SECRET" {
    type = string
}
variable "ARM_SUBSCRIPTION_ID" {
    type = string
}
variable "ARM_TENANT_ID" {
    type = string
}
variable "rg_name" {
    type = string
    description = "name of resource group"
}
variable "rg_location" {
    type = string
    description = "azure location"
}
variable "env" {
    type = string
    description = "environment tag (production, dev, etc)"
}
variable "vnet_name" {
    type = string
    description = "name of your zure vnet"
}
variable "vnet_cidr" {
    type = string
    description = "cidr block value for your vnet"
}
variable "subnet_cidr" {
    type = string
    description = "subnet cidr block"
}
variable "subnet_name" {
    type = string
    description = "subnet name"
}
variable "vm_name" {
    type = string
    description = "name of your vm"
}
variable "vm_admin" {
    type = string
    description = "admin username for vm"
}
variable "vm_size" {
    type = string
    description = "azure vm size"
}