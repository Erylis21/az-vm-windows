# Retrieve resource group to create the VM
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# Retrieve the key vault to enable encryption on the virtual machine and store credentials
data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Generate a random string for the admin username
resource "random_string" "admin_username" {
  length  = 8
  upper   = false
  number  = false
  lower   = true
  special = false

  keepers = {
    vm_name = var.virtual_machine_name
  }
}

# Admin username
locals {
  admin_name = "adm-${random_string.admin_username.result}"
}

# Generate password for virtual machine administrator
resource "random_password" "admin_password" {
  length = 20

  lower     = true
  min_lower = 4

  numeric  = true
  minumber = 4

  upper         = true
  min_min_upper = 4

  special          = true
  override_special = "!#$%&*-?"
  min_special      = 4

  keepers = {
    vm_name = var.virtual_machine_name
  }
}

# Create admin login entry in key vault
resource "azurerm_key_vault_secret" "kv_key_admin_username" {
  name         = format("login-%s", trimprefix(var.virtual_machine_name, "vm-"))
  value        = local.admin_name
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

resource "azurerm_key_vault_secret" "kv_key_admin_password" {
  name         = format("pass-%s", trimprefix(var.virtual_machine_name, "vm-"))
  value        = random_password.admin_password.result
  key_vault_id = data.azurerm_key_vault.key_vault.id
}

# Create key to encrypt the OS disk
resource "azurerm_key_vault_key" "osdisk_key" {
  name         = format("osdisk-%s", trimprefix(var.virtual_machine_name, "vm-"))
  key_vault_id = data.azurerm_key_vault.key_vault.id

  key_type = "RSA"
  key_size = 2048
  key_opts = ["unwrapKey", "wrapKey"]

  tags = var.tags
}

# Create disk encryption set to encrypt the OS disk
resource "azurerm_disk_encryption_set" "osdisk_des" {
  name                = format("des-osdisk-%s", trimprefix(var.virtual_machine_name, "vm-"))
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  key_vault_key_id    = azurerm_key_vault_key.osdisk_key.id

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Create access policy key
resource "azurerm_key_vault_access_policy" "osdisk_des" {
  key_vault_id = data.azurerm_key_vault.key_vault.id
  tenant_id    = azurerm_disk_encryption_set.osdisk_des.identity.0.tenant_id
  object_id    = azurerm_disk_encryption_set.osdisk_des.identity.0.principal_id

  key_permissions = [
    "Get",
    "UnwrapKey",
    "WrapKey",
  ]
}


# Retrieve the subnet in witch the vm network interface will be created
data "azurerm_subnet" "subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = data.azurerm_resource_group.rg.name
}

# Public Ip creation for the virtual machine
resource "azurerm_public_ip" "public_ip" {
  count = var.create_public_ip ? 1 : 0

  name                = format("pip-%s", trimprefix(var.virtual_machine_name, "vm-"))
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  allocation_method = "Static"
  sku               = var.public_ip_sku

  tags = var.tags
}

# Network interface Creation
resource "azurerm_network_interface" "network_interface" {
  name                = format("nic-%s", trimprefix(var.name, "vm-"))
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  enable_ip_forwarding = var.enable_ip_forwarding

  ip_configuration {
    name                          = var.ip_configuration_name != "" ? var.ip_configuration_name : "internal"
    subnet_id                     = data.azurerm_subnet.subnet.id
    private_ip_address_allocation = "Static"
    private_ip_address            = var.private_ip
    public_ip_address_id          = var.create_public_ip ? azurerm_public_ip.public_ip[0].id : ""
  }

  tags = var.tags
}

# Retrieve storage to enable boot diagnostic on the VM
data "azurerm_storage_account" "storage" {
  name                = var.storage_account_name
  resource_group_name = data.azurerm_resource_group.rg.name
}

# Virtual Machine Creation
resource "azurerm_windows_virtual_machine" "vm" {
  name                = var.virtual_machine_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location

  size           = var.virtual_machine_size
  admin_username = local.admin_name
  admin_password = random_password.password.result

  enable_automatic_updates = var.virtual_machine_autoupdate
  patch_mode               = var.virtual_machine_patch_mode
  timezone                 = var.virtual_machine_timezone

  network_interface_ids = [
    azurerm_network_interface.network_interface.id,
  ]

  os_disk {
    name                   = format("osdik-%s", trimprefix(var.virtual_machine_name, "vm-"))
    caching                = var.virtual_machine_disk_caching != "" ? var.virtual_machine_disk_caching : ""
    storage_account_type   = var.virtual_machine_disk_storage_account_type != "" ? var.virtual_machine_disk_storage_account_type : "StandardSSD_ZRS"
    disk_size_gb           = var.os_disk_size
    disk_encryption_set_id = azurerm_disk_encryption_set.disk_os_ecs.id
  }

  source_image_reference {
    publisher = var.virtual_machine_os_publisher
    offer     = var.virtual_machine_os_offer
    sku       = var.virtual_machine_os_sku
    version   = var.virtual_machine_os_version
  }

  boot_diagnostics {
    storage_account_uri = data.azurerm_storage_account.storage.primary_blob_endpoint
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

# Install the network watcher extension on the virtual machine
resource "azurerm_virtual_machine_extension" "extension_networkwatcher" {
  name                       = "vmext-networkWatcher"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentWindows"
  type_handler_version       = "1.4"
  auto_upgrade_minor_version = true

  tags = var.tags

  depends_on = [
    azurerm_windows_virtual_machine.vm
  ]
}

# Install the Microsoft anti malware extension on the virtual machine
resource "azurerm_virtual_machine_extension" "extension_antimalware" {
  name                       = "vmext-microsoftAntiMalware"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.7"
  auto_upgrade_minor_version = true

  settings = file("${path.module}/resources/antimalware-config.json")

  tags = var.tags

  depends_on = [
    azurerm_windows_virtual_machine.vm
  ]
}

#Get Backup policy
data "azurerm_backup_policy_vm" "backup_policy" {
  name                = var.backup_policy_name
  resource_group_name = var.recovery_vault_rg_name
  recovery_vault_name = var.recovery_vault_name
}

# Add VM in Backup Recovery Vault
resource "azurerm_backup_protected_vm" "backup_vm" {
  resource_group_name = var.recovery_vault_rg_name
  recovery_vault_name = var.recovery_vault_name
  source_vm_id        = azurerm_windows_virtual_machine.vm.id
  backup_policy_id    = data.azurerm_backup_policy_vm.backup_policy.id

  depends_on = [
    azurerm_windows_virtual_machine.vm,
    azurerm_virtual_machine_extension.extension_networkwatcher,
    azurerm_virtual_machine_extension.extension_antimalware
  ]
}
