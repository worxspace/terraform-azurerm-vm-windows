# tfm-azure-vm-windows

Creates azure windows virtual machines in a standardised way using the latest recommendations.

We use azurecaf\_name to generate a unique name for the user assigned identity.
so make sure to provide the project-name, prefixes, suffixes as necessary

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurecaf"></a> [azurecaf](#requirement\_azurecaf) | 2.0.0-preview3 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >=3.40.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurecaf"></a> [azurecaf](#provider\_azurecaf) | 2.0.0-preview3 |
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.53.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.5.1 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurecaf_name.name](https://registry.terraform.io/providers/aztfmod/azurecaf/2.0.0-preview3/docs/resources/name) | resource |
| [azurerm_managed_disk.disk](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/managed_disk) | resource |
| [azurerm_network_interface.nic](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_virtual_machine_data_disk_attachment.disk-attachment](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_data_disk_attachment) | resource |
| [azurerm_virtual_machine_extension.aadlogin](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.disk_encryption](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_computer-name"></a> [computer-name](#input\_computer-name) | value for the computer name of the virtual machine. Use this if the resource name being generated is longer than 15 | `string` | `null` | no |
| <a name="input_data-disks"></a> [data-disks](#input\_data-disks) | list of data disks to be attached to the virtual machine | <pre>list(object({<br>    name         = string<br>    storage-type = string<br>    tier         = optional(string)<br>    size-gb      = number<br>  }))</pre> | `null` | no |
| <a name="input_disk-encryption"></a> [disk-encryption](#input\_disk-encryption) | values used to enable Azure Disk Encryption. These are passed to the vm extension. The encryption url is the url to the encryption key. Make sure that the keyvault allows access for azure vms to connect to it and download the key | <pre>object({<br>    key-vault-url            = string<br>    key-vault-encryption-url = string<br>    key-vault-resource-id    = string<br>  })</pre> | `null` | no |
| <a name="input_enable-azuread-login"></a> [enable-azuread-login](#input\_enable-azuread-login) | value to determine if the virtual machine should be enabled for azure ad login | `bool` | `true` | no |
| <a name="input_global-tags"></a> [global-tags](#input\_global-tags) | tags to be applied to all resources | `map(string)` | `{}` | no |
| <a name="input_image-offer"></a> [image-offer](#input\_image-offer) | value for the offer of the image to be used for the virtual machine. Link to the list of available images: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage | `string` | `"WindowsServer"` | no |
| <a name="input_image-publisher"></a> [image-publisher](#input\_image-publisher) | value for the publisher of the image to be used for the virtual machine. Link to the list of available images: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage | `string` | `"MicrosoftWindowsServer"` | no |
| <a name="input_image-sku"></a> [image-sku](#input\_image-sku) | value for the sku of the image to be used for the virtual machine. Link to the list of available images: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage | `string` | `"2022-datacenter-azure-edition"` | no |
| <a name="input_image-version"></a> [image-version](#input\_image-version) | value for the version of the image to be used for the virtual machine. Link to the list of available images: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage | `string` | `"latest"` | no |
| <a name="input_ip-address"></a> [ip-address](#input\_ip-address) | value for the ip address of the virtual machine. Use this if you want to assign a specific ip address to the virtual machine | `string` | `null` | no |
| <a name="input_location"></a> [location](#input\_location) | value for the location of the virtual machines | `string` | `"switzerlandnorth"` | no |
| <a name="input_project-name"></a> [project-name](#input\_project-name) | used as the main part of the name of the virtual machine | `string` | n/a | yes |
| <a name="input_resource-group-name"></a> [resource-group-name](#input\_resource-group-name) | resource group where you want to create the virtual machines | `string` | n/a | yes |
| <a name="input_resource-prefixes"></a> [resource-prefixes](#input\_resource-prefixes) | these are prefixed to resource names and usually include the tenant short name and/or the environment name | `list(string)` | `[]` | no |
| <a name="input_resource-suffixes"></a> [resource-suffixes](#input\_resource-suffixes) | these are appended to resource names and usually include the numbers when multiple resource with the same name exist | `list(string)` | `[]` | no |
| <a name="input_subnet-id"></a> [subnet-id](#input\_subnet-id) | value for the subnet resource id where the virtual machine will be deployed | `string` | n/a | yes |
| <a name="input_support-hvic"></a> [support-hvic](#input\_support-hvic) | Determines if secure boot and vTPM are enabled on the virtual machine. This is only available for certain VM sizes. Link to the list of available sizes: https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-general | `bool` | `true` | no |
| <a name="input_update-management-integration"></a> [update-management-integration](#input\_update-management-integration) | Determines if the virtual machine should be integrated with Azure Update Management with periodic scanning | `bool` | `true` | no |
| <a name="input_vm-size"></a> [vm-size](#input\_vm-size) | value for the size of the virtual machine. Link to the list of available sizes: https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-general | `string` | `"Standard_D2s_V2"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin-password"></a> [admin-password](#output\_admin-password) | value for the admin password of the virtual machine |
| <a name="output_ip-address"></a> [ip-address](#output\_ip-address) | value for the ip address of the virtual machine |
| <a name="output_resource-id"></a> [resource-id](#output\_resource-id) | value for the resource id of the virtual machine |
