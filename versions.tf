#--------------------------------------------*--------------------------------------------
# Module: Azure Network Virtual Appliance - Single Fortinet - Vesions
#--------------------------------------------*--------------------------------------------

terraform {
  required_providers {
    azurecaf = {
      source  = "aztfmod/azurecaf"
      version = "2.0.0-preview3"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.4.0"
    }
  }
}

# end
#--------------------------------------------*--------------------------------------------
