output "ip-address" {
  value = azurerm_network_interface.nic.private_ip_address
  description = "value for the ip address of the virtual machine"
}

output "resource-id" {
  value = azurerm_windows_virtual_machine.vm.id
  description = "value for the resource id of the virtual machine"
}

output "admin-password" {
  value     = random_password.password.result
  sensitive = true
  description = "value for the admin password of the virtual machine"
}

output "network_interface_id" {
  value = azurerm_network_interface.nic.id
  description = "value for the network interface id of the virtual machine"
}