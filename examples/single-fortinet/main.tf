#--------------------------------------------*--------------------------------------------
# Example - Single Fortinet
#--------------------------------------------*--------------------------------------------

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = try(var.settings.location, "eastus")
  tags     = var.settings.tags 
}

resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  address_space       = ["192.168.0.0/24"]
  tags                = var.settings.tags
}

resource "azurerm_subnet" "publicsubnet" {
  name                 = "publicSubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["192.168.0.0/28"]
}

resource "azurerm_subnet" "privatesubnet" {
  name                 = "privateSubnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["192.168.0.16/28"]
}

resource "azurerm_network_security_group" "example" {
  name                = "nsg-example"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "all-inbound"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

    security_rule {
    name                       = "all-outbound"
    priority                   = 1001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags                = var.settings.tags
}

resource "azurerm_subnet_network_security_group_association" "publicsubnetnsg" {
  subnet_id     = azurerm_subnet.publicsubnet.id
  network_security_group_id = azurerm_network_security_group.example.id
}

resource "azurerm_subnet_network_security_group_association" "privatesubnetnsg" {
  subnet_id     = azurerm_subnet.privatesubnet.id
  network_security_group_id = azurerm_network_security_group.example.id
}



module "single_fortinet" {
  source = "../../"
  global_settings = var.settings.global_settings
  resource_group = azurerm_resource_group.example.name
  location = var.settings.location
  tags = var.settings.tags
  settings = try(var.settings)
  fortinet_trust_subnet_id = azurerm_subnet.privatesubnet.id
  fortinet_untrust_subnet_id = azurerm_subnet.publicsubnet.id
  fortinet_vm_username = var.settings.fortinet_vm_username
  fortinet_vm_password = var.settings.fortinet_vm_password
}


