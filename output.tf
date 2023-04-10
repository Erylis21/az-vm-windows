output "virtual_machine_id" {
  description = "ID of the virtual machine"
  value       = azurerm_windows_virtual_machine.vm.id
}

output "virtual_machine_ip" {
  description = "Private IP of the virtual machine"
  value       = azurerm_network_interface.network_interface.private_ip_address
}

output "virtual_machine_public_ip" {
  description = "Private IP of the virtual machine"
  value       = azurerm_public_ip.public_ip.ip_address
}

output "virtual_machine_admin_username" {
  description = "Admin username of the virtual machine"
  value       = local.admin_name
  sensitive   = true
}

output "virtual_machine_admin_password" {
  description = "Password of the virtual machine admin account"
  value       = azurerm_key_vault_secret.kv_key_admin_password.value
  sensitive   = true
}
