resource "azurerm_virtual_machine_extension" "disk_encryption" {

  count = var.disk-encryption == null ? 0 : 1

  name                       = "DiskEncryption"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.Security"
  type                       = "AzureDiskEncryption"
  type_handler_version       = 2.2
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
    {
        "EncryptionOperation": "EnableEncryption",
        "KeyVaultURL": "${var.disk-encryption.key-vault-url}",
        "KeyVaultResourceId": "${var.disk-encryption.key-vault-resource-id}",
        "KeyEncryptionKeyURL": "${var.disk-encryption.key-vault-encryption-url}",
        "KekVaultResourceId":"${var.disk-encryption.key-vault-resource-id}",
        "KeyEncryptionAlgorithm": "RSA-OAEP",
        "VolumeType": "All"
    }
SETTINGS


}
