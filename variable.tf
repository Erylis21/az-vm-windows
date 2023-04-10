variable "resource_group_name" {
  description = "Resource group name where the virtual machine will be created"
  type        = string
}

variable "key_vault_name" {
  description = "Keyvault name used to stored the different virtual machine keys"
  type        = string
}

variable "subnet_name" {
  description = "Subnet name where the virtual machine will be created"
  type        = string
}

variable "virtual_network_name" {
  description = "Virtual network name where the virtual machine will be created"
  type        = string
}

variable "create_public_ip" {
  description = "Indicate if an ip public should be created for the virtual machine"
  type        = bool
}

variable "public_ip_sku" {
  description = "SKU used for the public ip"
  type        = string

  validation {
    condition = anytrue([
      var.public_ip_sku == "Basic",
      var.public_ip_sku == "Standard"
    ])
    error_message = "Public IP SKU must be \"Basic\" or \"Standard\"."
  }
}

variable "enable_ip_forwarding" {
  description = "Indicate if ip forwarding is enable on the network interface"
  type        = bool
}

variable "ip_configuration_name" {
  description = "IP configuration name on the network interface"
  type        = string
  default     = ""

  validation {
    condition     = can(regex("^[a-z]+$", var.ip_configuration_name))
    error_message = "The ip_configuration_name value must contain only a-z charaters."
  }
}

variable "private_ip" {
  description = "Private IP attached to the virtual machine"
  type        = string

  validation {
    condition     = can(regex("^(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$", var.private_ip))
    error_message = "Invalid IP address provided."
  }
}

variable "storage_account_name" {
  description = "Storage account name used by the virtual machine to stored the boot diagnostic"
  type        = string
}

variable "virtual_machine_name" {
  description = "Name of the virtual machine"
  type        = string

  validation {
    condition     = length(var.virtual_machine_name) > 1 && length(var.virtual_machine_name) < 16
    error_message = "The virtual_machine_name value must be between 1 and 16 characters in length."
  }
  validation {
    condition     = substr(var.virtual_machine_name, 0, 3) == "vm-"
    error_message = "The virtual_machine_name value must start with \"vm-\"."
  }
  validation {
    condition     = can(regex("^[0-9a-z]+$", var.virtual_machine_name))
    error_message = "The virtual_machine_name value must contain only a-z, A-Z and 0-9 charaters."
  }
}

variable "virtual_machine_size" {
  description = "Virtual machine size"
  type        = string

  validation {
    condition = anytrue([
      var.virtual_machine_size == "Standard_DS2",
      var.virtual_machine_size == "Standard_D2",
      var.virtual_machine_size == "Standard_DS2_v2"
    ])
    error_message = "The virtual_machine_size value must be \"Standard_DS2\", \"Standard_D2\" or \"Standard_DS2_v2\"."
  }
}

variable "virtual_machine_autoupdate" {
  description = "Enable automatic update on the virtual machine"
  type        = bool
}

variable "virtual_machine_patch_mode" {
  description = "Mode to apply the patch on the virtual machine"
  type        = string

  validation {
    condition = anytrue([
      var.virtual_machine_patch_mode == "Manual",
      var.virtual_machine_patch_mode == "AutomaticByOS",
      var.virtual_machine_patch_mode == "AutomaticByPlatform"
    ])
    error_message = "The virtual_machine_patch_mode value must be \"Manual\", \"AutomaticByOS\" or \"AutomaticByPlatform\"."
  }
}

variable "virtual_machine_timezone" {
  description = "Timezone of the virtual machine"
  type        = string
  default     = "Romance Standard Time"
}

variable "virtual_machine_disk_caching" {
  description = "The type of caching which should be used for the OS disk"
  type        = string

  validation {
    condition = anytrue([
      var.virtual_machine_disk_caching == "None",
      var.virtual_machine_disk_caching == "ReadOnly",
      var.virtual_machine_disk_caching == "ReadWrite"
    ])
    error_message = "The virtual_machine_disk_caching value must be \"None\", \"ReadOnly\" or \"ReadWrite\"."
  }
}

variable "virtual_machine_disk_storage_account_type" {
  description = "The type of storage account which should back the OS Disk"
  type        = string

  validation {
    condition = anytrue([
      var.virtual_machine_disk_storage_account_type == "Standard_LRS",
      var.virtual_machine_disk_storage_account_type == "StandardSSD_LRS",
      var.virtual_machine_disk_storage_account_type == "Premium_LRS",
      var.virtual_machine_disk_storage_account_type == "StandardSSD_ZRS",
      var.virtual_machine_disk_storage_account_type == "Premium_ZRS"
    ])
    error_message = "The virtual_machine_disk_storage_account_type value must be \"Standard_LRS\", \"StandardSSD_LRS\", \"Premium_LRS\", \"StandardSSD_ZRS\", or \"Premium_ZRS\"."
  }
}

variable "os_disk_size" {
  description = "Size of the OS disk in GB"
  type        = number
}

variable "virtual_machine_os_publisher" {
  description = "Specifies the publisher of the image used to create the virtual machine"
  type        = string
  default     = "MicrosoftWindowsServer"
}

variable "virtual_machine_os_offer" {
  description = "Specifies the offer of the image used to create the virtual machine"
  type        = string
  default     = "WindowsServer"
}
variable "virtual_machine_os_sku" {
  description = "Specifies the SKU of the image used to create the virtual machine"
  type        = string
  default     = "2022-datacenter-azure-edition"
}
variable "virtual_machine_os_version" {
  description = "Specifies the version of the image used to create the virtual machine"
  type        = string
  default     = "latest"
}

variable "backup_policy_name" {
  description = "Name of the backup policy used for the virtual machine"
  type        = string
}

variable "recovery_vault_rg_name" {
  description = "Resource group name of the recovery service vault used to backup the virtual machine"
  type        = string
}

variable "recovery_vault_name" {
  description = "Name of the recovery service vault used to backup the virtual machine"
  type        = string
}
