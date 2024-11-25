#--------------------------------------------*--------------------------------------------
# Module: Azure Network Virtual Appliance - Single Fortinet - Variables
#--------------------------------------------*--------------------------------------------

variable "global_settings" {
  description = "Global settings for the naming convention"
}

variable "settings" {
  description = "Settings for the Single Fortinet module"
  
}

variable "fortinet_vm_username" {
  description = "The username for the Fortinet VM"
  type        = string      
  
}

variable "fortinet_vm_password" {
  description = "The username for the Fortinet VM"
  type        = string      
}

variable "fortinet_trust_subnet_id" {
  description = "The ID of the trust subnet where the Fortinet will be deployed"
  type        = string
}

variable "fortinet_untrust_subnet_id" {
  description = "The ID of the untrust subnet where the Fortinet will be deployed"
  type        = string
}

variable "resource_group" {
  description = "The name of the resource group in which the resources will be created"
  type        = string  
}

variable "location" {
  description = "The location/region where the resources will be created"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}



# end
#--------------------------------------------*--------------------------------------------