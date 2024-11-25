#--------------------------------------------*--------------------------------------------
# Module: Azure Network Virtual Appliance - Single Fortinet - Main
#--------------------------------------------*--------------------------------------------


# Fortinet Public IP

resource "azurecaf_name" "fgt_public_ip" {
  name          = lookup(var.settings.network, "fortinet_prefix", null)
  resource_type = "azurerm_public_ip"
  prefixes      = lookup(var.global_settings, "prefixes", [])
  suffixes      = lookup(var.global_settings, "suffixes", [])
  passthrough   = lookup(var.global_settings, "passthrough", false)
  clean_input   = lookup(var.global_settings, "clean_input", true)
  separator     = lookup(var.global_settings, "separator", "-")
  random_length = lookup(var.global_settings, "random_length", 0)
  random_seed   = lookup(var.global_settings, "random_seed", 1) 
  use_slug      = lookup(var.global_settings, "use_slug", true)
}

resource "azurerm_public_ip" "fgt_public_ip" {
  for_each            = toset(try(var.settings.network.public_ip_prefix, [])) 
  name                = format("%s-%s", azurecaf_name.fgt_public_ip.result, each.key)
  location            = var.location
  resource_group_name = var.resource_group
  allocation_method   = "Static"
  tags                = var.tags
}

# Fortinet Network Interfaces

resource "azurerm_network_interface" "fgt_untrust_port1" {
  depends_on            = [ 
                          azurerm_public_ip.fgt_public_ip
                          ]
  name                  = lower(format("%s_%s_%s_%s", "nic", lookup(var.settings, "fortinet_vm_name", null) , "p1", "untrust"))
  location              = var.location
  resource_group_name   = var.resource_group

  ip_configuration {
    name                          = "ipconfig_p1_untrust"
    subnet_id                     = var.fortinet_untrust_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = lookup(var.settings.network, "untrust_ip", null)
    public_ip_address_id          = azurerm_public_ip.fgt_public_ip["untrust"].id
  }
    tags = var.tags
}

resource "azurerm_network_interface" "fgt_trust_port2" {
  name                  = lower(format("%s_%s_%s_%s", "nic", lookup(var.settings, "fortinet_vm_name", null), "p2", "trust"))
  location              = var.location
  resource_group_name   = var.resource_group
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "ipconfig_p2_trust"
    subnet_id                     = var.fortinet_trust_subnet_id
    private_ip_address_allocation = "Static"
    private_ip_address            = lookup(var.settings.network, "trust_ip", null)
  }
    tags = var.tags
}

# Fortinet Storage Account

resource "random_id" "this" {
  keepers = {
    resource_group = var.resource_group
  }

  byte_length = 3
}

resource "azurerm_storage_account" "this" {
  name                     = format("%s%s%s","stdiag", lookup(var.settings.network, "fortinet_prefix", null), random_id.this.hex)
  resource_group_name      = var.resource_group
  location                 = var.location
  account_replication_type = "LRS"
  account_tier             = "Standard"
  account_kind             = "StorageV2"
  access_tier              = "Cool"    
  min_tls_version          = "TLS1_2"      
  tags                     = var.tags
}

# Fortinet Marketplace Agreement

resource "azurerm_marketplace_agreement" "this" {
  count     = lookup(var.settings, "fortinet_accept_agreement", false) ? 1 : 0
  publisher = lookup(var.settings, "fortinet_publisher_id", null)
  offer     = lookup(var.settings, "fortinet_offer_id", null)
  plan      = lookup(var.settings, "fortinet_license_type", "payg") == "payg" ? try(var.settings.fortinet_sku_id["payg"], null) : try(var.settings.fortinet_sku_id["byol"], null)
}

# Fortinet Virtual Machine

resource "azurerm_virtual_machine" "fgt-vm" {
  depends_on                          = [ 
                                        azurerm_network_interface.fgt_untrust_port1,
                                        azurerm_network_interface.fgt_trust_port2,
                                        azurerm_marketplace_agreement.this,
                                        azurerm_storage_account.this
   ]
  zones                               = lookup(var.settings, "zones", [1])
  name                                = lookup(var.settings, "fortinet_vm_name", null)
  location                            = var.location
  resource_group_name                 = var.resource_group
  tags                                = var.tags
  network_interface_ids               = [
                                          azurerm_network_interface.fgt_untrust_port1.id,
                                          azurerm_network_interface.fgt_trust_port2.id
                                        ]
  primary_network_interface_id        = azurerm_network_interface.fgt_untrust_port1.id
  vm_size                             = lookup(var.settings, "fortinet_vm_size", "Standard_F4")
  delete_os_disk_on_termination       = lookup(var.settings, "delete_os_disk_on_termination", false)
  delete_data_disks_on_termination    = lookup(var.settings, "delete_data_disks_on_termination", false)

  storage_image_reference {
    publisher                         = lookup(var.settings, "fortinet_publisher_id", null)
    offer                             = lookup(var.settings, "fortinet_offer_id", null)
    sku                               = lookup(var.settings, "fortinet_license_type", "payg") == "payg" ? try(var.settings.fortinet_sku_id["payg"], null) : try(var.settings.fortinet_sku_id["byol"], null)
    version                           = lookup(var.settings, "fortinet_version", null)
  }

  plan {
    name                             = lookup(var.settings, "fortinet_license_type", "payg") == "payg" ? try(var.settings.fortinet_sku_id["payg"], null) : try(var.settings.fortinet_sku_id["byol"], null)
    publisher                        = lookup(var.settings, "fortinet_publisher_id", null)
    product                          = lookup(var.settings, "fortinet_offer_id", null)
  }

  storage_os_disk {
    name                            = lower(format("%s_%s_%s", "md", "osdisk", lookup(var.settings, "fortinet_vm_name", null)))
    caching                         = lookup(var.settings, "os_caching_disk", "ReadWrite")
    managed_disk_type               = lookup(var.settings, "disk_type", "Standard_LRS")
    create_option                   = "FromImage"
  }

  # Log data disks
  storage_data_disk {
    name                          = lower(format("%s_%s_%s", "md", "da", lookup(var.settings, "fortinet_vm_name", null)))
    managed_disk_type             = lookup(var.settings, "disk_type", "Standard_LRS")
    create_option                 = "Empty"
    lun                           = 0
    disk_size_gb                  = "30"
  }

  os_profile {
    computer_name                 = lookup(var.settings, "fortinet_vm_name", null)
    admin_username                = var.fortinet_vm_username
    admin_password                = var.fortinet_vm_password
    custom_data                   = templatefile(format("%s/fgt_single_vm.conf", path.module), {
                                      hostname        = lookup(var.settings, "fortinet_vm_name", null)
                                      type            = lookup(var.settings, "fortinet_license_type", "payg")
                                      license_file    = lookup(var.settings, "fortinet_license_file", "license.txt")
                                      format          = lookup(var.settings, "fortinet_license_format", "token")
                                      untrust_ip      = lookup(var.settings.network, "untrust_ip", null)
                                      untrust_netmask = lookup(var.settings.network, "untrust_netmask", null)
                                      untrust_gateway = lookup(var.settings.network, "untrust_gateway", null)
                                      trust_netmask   = lookup(var.settings.network, "trust_netmask", null)
                                      trust_ip        = lookup(var.settings.network, "trust_ip", null)
                                    })

  }

  os_profile_linux_config {
    disable_password_authentication = lookup(var.settings, "disable_password_authentication", true)
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = azurerm_storage_account.this.primary_blob_endpoint
  }

}


# end
#--------------------------------------------*--------------------------------------------