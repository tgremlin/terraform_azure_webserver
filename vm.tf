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
    public_key = file("./secrets/ubuntu_rsa.pub")
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage_account.primary_blob_endpoint
  }

  provisioner "remote-exec" {
    inline = ["sudo apt-get -qq install python software-properties-common -y",
    "sudo add-apt-repository ppa:deadsnakes/ppa -y",
    "sudo apt update",
    "sudo apt install python3.8 -y",]

      connection {
        type = "ssh"
        host = self.public_ip_address
        private_key = file("./secrets/ubuntu_rsa")
        user = var.vm_admin
  }
  }

  tags = {
    environment = var.env
  }
}

resource "null_resource" "run_ansible" {
  provisioner "local-exec" {
    command = "sudo ansible-playbook --private-key ./secrets/ubuntu_rsa -i ${var.vm_admin}@${azurerm_linux_virtual_machine.vm.public_ip_address}, playbook.yml"
  }
}

