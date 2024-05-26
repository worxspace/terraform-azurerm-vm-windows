# domain join vm extension
resource "azurerm_virtual_machine_extension" "domainjoin" {
  count = var.domain-join-info != null ? 1 : 0

  name                 = "domainjoin"
  virtual_machine_id   = azurerm_windows_virtual_machine.vm.id
  publisher            = "Microsoft.Compute"
  type                 = "JsonADDomainExtension"
  type_handler_version = "1.3"
  auto_upgrade_minor_version = true

  settings = jsonencode({
    Name                = var.domain-join-info.domain
    OUPath              = var.domain-join-info.ou
    User                = var.domain-join-info.username
    Restart             = "true"
    Options             = "3"
    Password            = var.domain-join-info.password
  })

  protected_settings = jsonencode({
    Password = var.domain-join-info.password
  })
}