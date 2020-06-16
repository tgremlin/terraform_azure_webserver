# resource "tls_private_key" "ssh" {
#   algorithm = "RSA"
#   rsa_bits = 4096
# }

# output "tls_private_key" {
#     value = tls_private_key.ssh.private_key_pem
# }

resource "azurerm_linux_virtual_machine" "vm" {
  name = var.vm_name
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  network_interface_ids = [azurerm_network_interface.nic.id]
  size = var.vm_size

  os_disk {
    name = "${var.vm_name}-os-disk"
    caching = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "18.04-LTS"
    version = "latest"
  }

  computer_name = var.vm_name
  admin_username = var.vm_admin
  disable_password_authentication = true

  admin_ssh_key {
    username = var.vm_admin
    public_key = file("./secrets/ubuntu_ssh.pub")
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage_account.primary_blob_endpoint
  }

  tags = {
    environment = var.env
  }
}

# resource "azurerm_virtual_machine_extension" "install_webserver" {
#   name  = "hostname"
#   virtual_machine_id    = azurerm_linux_virtual_machine.vm.id
#   publisher = "Microsoft.Azure.Extensions"
#   type  = "CustomScript"
# }