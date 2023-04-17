output "ip-address" {
  value = azurerm_network_interface.nic.private_ip_address
}

output "resource-id" {
  value = azurerm_windows_virtual_machine.vm.id
}

output "admin-password" {
  value     = random_password.password.result
  sensitive = true
}