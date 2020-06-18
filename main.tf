provider "azurerm" {
    version = "=2.14.0"

    subscription_id = var.ARM_SUBSCRIPTION_ID
    client_id = var.ARM_CLIENT_ID
    client_secret = var.ARM_CLIENT_SECRET
    tenant_id = var.ARM_TENANT_ID

features {}
}

resource "azurerm_resource_group" "rg" {
  name      = var.rg_name
  location  = var.rg_location

  tags = {
    environment = var.env
  }
}

output "pub_ip" {
    value = azurerm_linux_virtual_machine.vm.public_ip_address
}

