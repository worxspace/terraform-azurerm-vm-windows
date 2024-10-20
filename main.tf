/**
 * # tfm-azure-vm-windows
 *
 * Creates azure windows virtual machines in a standardised way using the latest recommendations.
 *
 * We use azurecaf_name to generate a unique name for the user assigned identity.
 * so make sure to provide the project-name, prefixes, suffixes as necessary
 */

module "names" {
  source  = "app.terraform.io/worxspace/name/azurecaf"
  version = "~>0.0.2"

  resource_types = [
    "azurerm_linux_virtual_machine"
  ]
  name     = var.project-name
  prefixes = var.resource-prefixes
  suffixes = var.machine-index == null ? var.resource-suffixes : concat(var.resource-suffixes, [format("%03d", var.machine-index)])

  random_length = var.random-resource-suffix-length
}

resource "random_integer" "nic-seed" {
  min = 1
  max = 50000
  keepers = {
    name          = module.names.results.azurerm_linux_virtual_machine
    computer_name = module.names.results.azurerm_linux_virtual_machine
  }
  seed = module.names.results.azurerm_linux_virtual_machine
}

resource "azurecaf_name" "nic" {
  resource_type = "azurerm_network_interface"
  prefixes      = var.resource-prefixes
  suffixes      = var.resource-suffixes
  random_length = "5"
  random_seed   = random_integer.nic-seed.result
}

resource "azurerm_network_interface" "nic" {
  name                = azurecaf_name.nic.result
  location            = var.location
  resource_group_name = var.resource-group-name

  accelerated_networking_enabled = var.enable_accelerated_networking

  dynamic "ip_configuration" {
    for_each = var.ip-address == null ? [] : [var.ip-address]

    content {
      name                          = "internal"
      subnet_id                     = var.subnet-id
      private_ip_address_allocation = "Static"
      private_ip_address            = ip_configuration.value
    }
  }

  dynamic "ip_configuration" {
    for_each = var.ip-address == null ? [1] : []

    content {
      name                          = "internal"
      subnet_id                     = var.subnet-id
      private_ip_address_allocation = "Dynamic"
    }
  }

  tags = var.global-tags
}

resource "random_password" "password" {
  length  = 24
  special = true
}

resource "azurerm_marketplace_agreement" "ma" {
  count = var.plan != null ? 1 : 0

  publisher = var.plan.publisher
  offer     = var.plan.product
  plan      = var.plan.name
}

resource "azurerm_windows_virtual_machine" "vm" {
  name                = module.names.results.azurerm_linux_virtual_machine
  computer_name       = var.computer-name == null ? replace(module.names.results.azurerm_linux_virtual_machine, "-", "") : var.computer-name
  resource_group_name = var.resource-group-name
  location            = var.location
  size                = var.vm-size
  admin_username      = "adminuser"
  admin_password      = random_password.password.result
  network_interface_ids = [
    azurerm_network_interface.nic.id
  ]
  availability_set_id = var.availability_set_id

  os_disk {
    name                 = azurecaf_name.disk["osdisk"].result
    caching              = "ReadWrite"
    storage_account_type = var.os-disk-storage-type
  }

  source_image_id = var.source-image-id

  dynamic "source_image_reference" {
    for_each = var.source-image-id == null ? [1] : []

    content {
      publisher = var.image-publisher
      offer     = var.image-offer
      sku       = var.image-sku
      version   = var.image-version
    }
  }

  secure_boot_enabled = var.support-hvic
  vtpm_enabled        = var.support-hvic
  license_type        = var.license_type

  hotpatching_enabled      = false # enable later when image supports
  patch_assessment_mode    = var.update-management-integration ? "AutomaticByPlatform" : "ImageDefault"
  patch_mode               = var.update-management-integration ? "AutomaticByPlatform" : "Manual"
  enable_automatic_updates = var.update-management-integration

  tags = var.global-tags

  dynamic "identity" {
    for_each = [var.disk-encryption == null ? null : var.disk-encryption]

    content {
      type = "SystemAssigned"
    }
  }

  dynamic "plan" {
    for_each = var.plan != null ? [1] : []

    content {
      name      = azurerm_marketplace_agreement.ma[0].plan
      publisher = azurerm_marketplace_agreement.ma[0].publisher
      product   = azurerm_marketplace_agreement.ma[0].offer
    }
  }
}

resource "random_integer" "disk-seed" {
  for_each = { for disk in concat([{ name = "osdisk" }], var.data-disks) : disk.name => disk }

  min = 1
  max = 50000
  keepers = {
    name          = each.key
    computer_name = module.names.results.azurerm_linux_virtual_machine
  }
  seed = "${module.names.results.azurerm_linux_virtual_machine}-${each.key}"
}

resource "azurecaf_name" "disk" {
  for_each = { for disk in concat([{ name = "osdisk" }], var.data-disks) : disk.name => disk }

  resource_type = "azurerm_managed_disk"
  prefixes      = var.resource-prefixes
  suffixes      = var.resource-suffixes
  random_length = "5"
  random_seed   = random_integer.disk-seed[each.key].result
}

resource "azurerm_managed_disk" "disk" {
  for_each = var.data-disks == null ? {} : { for disk in var.data-disks : disk.name => disk }

  name                 = azurecaf_name.disk[each.key].result
  location             = var.location
  resource_group_name  = var.resource-group-name
  storage_account_type = each.value.storage-type
  tier                 = each.value.tier
  create_option        = "Empty"
  disk_size_gb         = each.value.size-gb

  tags = var.global-tags

  lifecycle {
    ignore_changes = [
      encryption_settings
    ]
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "disk-attachment" {
  for_each = azurerm_managed_disk.disk

  managed_disk_id    = each.value.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = "10"
  caching            = "None"
}

resource "azurerm_virtual_machine_extension" "aadlogin" {
  count = var.enable-azuread-login ? 1 : 0

  name                       = "AADLoginForWindows"
  virtual_machine_id         = azurerm_windows_virtual_machine.vm.id
  publisher                  = "Microsoft.Azure.ActiveDirectory"
  type                       = "AADLoginForWindows"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
}
