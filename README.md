<!-- BEGIN_TF_DOCS -->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<br />
<div align="center">
<h1 align="center">AZ-VM-WINDOWS</h1>

  <p align="justify">
    Terraform module to deploy Azure Windows virtual machines with Public IP, Os Disk Encryption Set, Boot Diagnostics, Network Watcher and AntiMalware extension. It creates random admin username and passwords and store it inside an Azure key vault.
  </p>
</div>

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.50.0 |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.50.0 |

## Usage
Basic usage of this module is as follows:
```hcl
module "example" {
	 source  = "<module-path>"

	 # Required variables
	 backup_policy_name  = 
	 create_public_ip  = 
	 enable_ip_forwarding  = 
	 key_vault_name  = 
	 os_disk_size  = 
	 private_ip  = 
	 public_ip_sku  = 
	 recovery_vault_name  = 
	 recovery_vault_rg_name  = 
	 resource_group_name  = 
	 storage_account_name  = 
	 subnet_name  = 
	 virtual_machine_autoupdate  = 
	 virtual_machine_disk_caching  = 
	 virtual_machine_disk_storage_account_type  = 
	 virtual_machine_name  = 
	 virtual_machine_patch_mode  = 
	 virtual_machine_size  = 
	 virtual_network_name  = 

	 # Optional variables
	 ip_configuration_name  = ""
	 virtual_machine_os_offer  = "WindowsServer"
	 virtual_machine_os_publisher  = "MicrosoftWindowsServer"
	 virtual_machine_os_sku  = "2022-datacenter-azure-edition"
	 virtual_machine_os_version  = "latest"
	 virtual_machine_timezone  = "Romance Standard Time"
}
```
## Resources

| Name | Type |
|------|------|
| [azurerm_backup_protected_vm.backup_vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_protected_vm) | resource |
| [azurerm_disk_encryption_set.osdisk_des](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/disk_encryption_set) | resource |
| [azurerm_key_vault_access_policy.osdisk_des](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_key_vault_key.osdisk_key](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_key) | resource |
| [azurerm_key_vault_secret.kv_key_admin_password](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_key_vault_secret.kv_key_admin_username](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_network_interface.network_interface](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_interface) | resource |
| [azurerm_public_ip.public_ip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_virtual_machine_extension.extension_antimalware](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_virtual_machine_extension.extension_networkwatcher](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/virtual_machine_extension) | resource |
| [azurerm_windows_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/windows_virtual_machine) | resource |
| [random_password.admin_password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) | resource |
| [random_string.admin_username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) | resource |
| [azurerm_backup_policy_vm.backup_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/backup_policy_vm) | data source |
| [azurerm_key_vault.key_vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/key_vault) | data source |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_storage_account.storage](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/storage_account) | data source |
| [azurerm_subnet.subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_policy_name"></a> [backup\_policy\_name](#input\_backup\_policy\_name) | Name of the backup policy used for the virtual machine | `string` | n/a | yes |
| <a name="input_create_public_ip"></a> [create\_public\_ip](#input\_create\_public\_ip) | Indicate if an ip public should be created for the virtual machine | `bool` | n/a | yes |
| <a name="input_enable_ip_forwarding"></a> [enable\_ip\_forwarding](#input\_enable\_ip\_forwarding) | Indicate if ip forwarding is enable on the network interface | `bool` | n/a | yes |
| <a name="input_ip_configuration_name"></a> [ip\_configuration\_name](#input\_ip\_configuration\_name) | IP configuration name on the network interface | `string` | `""` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | Keyvault name used to stored the different virtual machine keys | `string` | n/a | yes |
| <a name="input_os_disk_size"></a> [os\_disk\_size](#input\_os\_disk\_size) | Size of the OS disk in GB | `number` | n/a | yes |
| <a name="input_private_ip"></a> [private\_ip](#input\_private\_ip) | Private IP attached to the virtual machine | `string` | n/a | yes |
| <a name="input_public_ip_sku"></a> [public\_ip\_sku](#input\_public\_ip\_sku) | SKU used for the public ip | `string` | n/a | yes |
| <a name="input_recovery_vault_name"></a> [recovery\_vault\_name](#input\_recovery\_vault\_name) | Name of the recovery service vault used to backup the virtual machine | `string` | n/a | yes |
| <a name="input_recovery_vault_rg_name"></a> [recovery\_vault\_rg\_name](#input\_recovery\_vault\_rg\_name) | Resource group name of the recovery service vault used to backup the virtual machine | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | Resource group name where the virtual machine will be created | `string` | n/a | yes |
| <a name="input_storage_account_name"></a> [storage\_account\_name](#input\_storage\_account\_name) | Storage account name used by the virtual machine to stored the boot diagnostic | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | Subnet name where the virtual machine will be created | `string` | n/a | yes |
| <a name="input_virtual_machine_autoupdate"></a> [virtual\_machine\_autoupdate](#input\_virtual\_machine\_autoupdate) | Enable automatic update on the virtual machine | `bool` | n/a | yes |
| <a name="input_virtual_machine_disk_caching"></a> [virtual\_machine\_disk\_caching](#input\_virtual\_machine\_disk\_caching) | The type of caching which should be used for the OS disk | `string` | n/a | yes |
| <a name="input_virtual_machine_disk_storage_account_type"></a> [virtual\_machine\_disk\_storage\_account\_type](#input\_virtual\_machine\_disk\_storage\_account\_type) | The type of storage account which should back the OS Disk | `string` | n/a | yes |
| <a name="input_virtual_machine_name"></a> [virtual\_machine\_name](#input\_virtual\_machine\_name) | Name of the virtual machine | `string` | n/a | yes |
| <a name="input_virtual_machine_os_offer"></a> [virtual\_machine\_os\_offer](#input\_virtual\_machine\_os\_offer) | Specifies the offer of the image used to create the virtual machine | `string` | `"WindowsServer"` | no |
| <a name="input_virtual_machine_os_publisher"></a> [virtual\_machine\_os\_publisher](#input\_virtual\_machine\_os\_publisher) | Specifies the publisher of the image used to create the virtual machine | `string` | `"MicrosoftWindowsServer"` | no |
| <a name="input_virtual_machine_os_sku"></a> [virtual\_machine\_os\_sku](#input\_virtual\_machine\_os\_sku) | Specifies the SKU of the image used to create the virtual machine | `string` | `"2022-datacenter-azure-edition"` | no |
| <a name="input_virtual_machine_os_version"></a> [virtual\_machine\_os\_version](#input\_virtual\_machine\_os\_version) | Specifies the version of the image used to create the virtual machine | `string` | `"latest"` | no |
| <a name="input_virtual_machine_patch_mode"></a> [virtual\_machine\_patch\_mode](#input\_virtual\_machine\_patch\_mode) | Mode to apply the patch on the virtual machine | `string` | n/a | yes |
| <a name="input_virtual_machine_size"></a> [virtual\_machine\_size](#input\_virtual\_machine\_size) | Virtual machine size | `string` | n/a | yes |
| <a name="input_virtual_machine_timezone"></a> [virtual\_machine\_timezone](#input\_virtual\_machine\_timezone) | Timezone of the virtual machine | `string` | `"Romance Standard Time"` | no |
| <a name="input_virtual_network_name"></a> [virtual\_network\_name](#input\_virtual\_network\_name) | Virtual network name where the virtual machine will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_virtual_machine_admin_password"></a> [virtual\_machine\_admin\_password](#output\_virtual\_machine\_admin\_password) | Password of the virtual machine admin account |
| <a name="output_virtual_machine_admin_username"></a> [virtual\_machine\_admin\_username](#output\_virtual\_machine\_admin\_username) | Admin username of the virtual machine |
| <a name="output_virtual_machine_id"></a> [virtual\_machine\_id](#output\_virtual\_machine\_id) | ID of the virtual machine |
| <a name="output_virtual_machine_ip"></a> [virtual\_machine\_ip](#output\_virtual\_machine\_ip) | Private IP of the virtual machine |
| <a name="output_virtual_machine_public_ip"></a> [virtual\_machine\_public\_ip](#output\_virtual\_machine\_public\_ip) | Private IP of the virtual machine |

## License

MIT License - Copyright (c) 2023 The terraform-docs Authors.

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/Erylis21/repo_name.svg?style=for-the-badge
[contributors-url]: https://github.com/Erylis21/az-vm-windows/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Erylis21/az-vm-windows.svg?style=for-the-badge
[forks-url]: https://github.com/Erylis21/az-vm-windows/network/members
[stars-shield]: https://img.shields.io/github/stars/Erylis21/az-vm-windows.svg?style=for-the-badge
[stars-url]: https://github.com/Erylis21/az-vm-windows/stargazers
[issues-shield]: https://img.shields.io/github/issues/Erylis21/az-vm-windows.svg?style=for-the-badge
[issues-url]: https://github.com/Erylis21/az-vm-windows/issues
[license-shield]: https://img.shields.io/github/license/Erylis21/az-vm-windows.svg?style=for-the-badge
[license-url]: https://github.com/Erylis21/az-vm-windows/blob/main/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/linkedin_username
<!-- END_TF_DOCS -->