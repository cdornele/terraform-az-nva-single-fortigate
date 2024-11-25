# Azure Network Virtual Appliance 
## Fortigate Single VM

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | 2.0.0-preview3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | 4.4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | 2.0.0-preview3 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.fgt_public_ip](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/resources/name) | resource |
| [azurerm_marketplace_agreement.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.4.0/docs/resources/marketplace_agreement) | resource |
| [azurerm_network_interface.fgt_trust_port2](https://registry.terraform.io/providers/hashicorp/azurerm/4.4.0/docs/resources/network_interface) | resource |
| [azurerm_network_interface.fgt_untrust_port1](https://registry.terraform.io/providers/hashicorp/azurerm/4.4.0/docs/resources/network_interface) | resource |
| [azurerm_public_ip.fgt_public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/4.4.0/docs/resources/public_ip) | resource |
| [azurerm_storage_account.this](https://registry.terraform.io/providers/hashicorp/azurerm/4.4.0/docs/resources/storage_account) | resource |
| [azurerm_virtual_machine.fgt-vm](https://registry.terraform.io/providers/hashicorp/azurerm/4.4.0/docs/resources/virtual_machine) | resource |
| [random_id.this](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_fortinet_trust_subnet_id"></a> [fortinet\_trust\_subnet\_id](#input\_fortinet\_trust\_subnet\_id) | The ID of the trust subnet where the Fortinet will be deployed | `string` | n/a | yes |
| <a name="input_fortinet_untrust_subnet_id"></a> [fortinet\_untrust\_subnet\_id](#input\_fortinet\_untrust\_subnet\_id) | The ID of the untrust subnet where the Fortinet will be deployed | `string` | n/a | yes |
| <a name="input_fortinet_vm_password"></a> [fortinet\_vm\_password](#input\_fortinet\_vm\_password) | The username for the Fortinet VM | `string` | n/a | yes |
| <a name="input_fortinet_vm_username"></a> [fortinet\_vm\_username](#input\_fortinet\_vm\_username) | The username for the Fortinet VM | `string` | n/a | yes |
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | Global settings for the naming convention | `any` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the resources will be created | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | The name of the resource group in which the resources will be created | `string` | n/a | yes |
| <a name="input_settings"></a> [settings](#input\_settings) | Settings for the Single Fortinet module | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->