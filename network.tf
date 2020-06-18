#Create Azure Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name = var.vnet_name
  address_space = [var.vnet_cidr]
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  tags = {
    environment = var.env
  }
}

#Create azure subnet
resource "azurerm_subnet" "subnet" {
  name = var.subnet_name
  resource_group_name = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes = ["${var.subnet_cidr}"]
}

#Create vnet public ip
resource "azurerm_public_ip" "pub_ip" {
  name = "${azurerm_virtual_network.vnet.name}-public-ip"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method = "Dynamic"

  tags = {
    environment = var.env
  }
}

#Create network security group
resource "azurerm_network_security_group" "sg" {
  name  = "${azurerm_virtual_network.vnet.name}-security-group"
  location  = azurerm_resource_group.rg.location
  resource_group_name   = azurerm_resource_group.rg.name

  security_rule {
      name                          = "SSH"
      priority                      = 1001
      direction                     = "Inbound"
      access                        = "Allow"
      protocol                      = "Tcp"
      source_port_range             = "*"
      destination_port_range        = "22"
      source_address_prefix         = "*"
      destination_address_prefix    = "*"
  }

  security_rule {
    name                            = "web"
    priority                        = 1002
    direction                       = "Inbound"
    access                          = "Allow"
    protocol                        = "Tcp"
    source_port_range               = "*"
    destination_port_range          = "80"
    source_address_prefix           = "*"
    destination_address_prefix      = "*"

  }

  tags  = {
      environment   = var.env
  }
}

#Create network interface
resource "azurerm_network_interface" "nic" {
  name = "${azurerm_subnet.subnet.name}-NIC"
  location = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name = "IP-CONFIG"
    subnet_id = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.pub_ip.id
  }

  tags = {
    environment = var.env
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nic-sg-assoc" {
  network_interface_id = azurerm_network_interface.nic.id
  network_security_group_id = azurerm_network_security_group.sg.id
}

