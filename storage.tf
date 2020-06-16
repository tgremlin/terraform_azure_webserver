resource "random_id" "randomId" {
  keepers = {
      # Generate a new ID when resource group is defined
      resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

resource "azurerm_storage_account" "storage_account" {
  name = "diag${random_id.randomId.hex}"
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_replication_type = "LRS"
  access_tier = "Hot"
  account_tier = "Standard"

  tags = {
    environment = var.env
  }
}
