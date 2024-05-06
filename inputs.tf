variable "resource-group-name" {
  description = "resource group where you want to create the virtual machines"
  type        = string
}

variable "location" {
  type        = string
  default     = "switzerlandnorth"
  description = "value for the location of the virtual machines"
}

variable "project-name" {
  type        = string
  description = "used as the main part of the name of the virtual machine"
}

variable "resource-prefixes" {
  type        = list(string)
  description = "these are prefixed to resource names and usually include the tenant short name and/or the environment name"

  default = []
}

variable "resource-suffixes" {
  type        = list(string)
  description = "these are appended to resource names and usually include the numbers when multiple resource with the same name exist"

  default = []
}

variable "random-resource-suffix-length" {
  type        = number
  description = "this will add a random string to the end of your resources using a-z and 0-9 upto the number specified"

  default = 0
}

variable "computer-name" {
  type        = string
  default     = null
  description = "value for the computer name of the virtual machine. Use this if the resource name being generated is longer than 15"
}

variable "subnet-id" {
  type        = string
  description = "value for the subnet resource id where the virtual machine will be deployed"
}

variable "ip-address" {
  type        = string
  default     = null
  description = "value for the ip address of the virtual machine. Use this if you want to assign a specific ip address to the virtual machine"
}

variable "vm-size" {
  type        = string
  default     = "Standard_D2s_V2"
  description = "value for the size of the virtual machine. Link to the list of available sizes: https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-general"
}

variable "os-disk-storage-type" {
  type        = string
  default     = "Standard_LRS"
  description = "value for the storage type of the os disk of the virtual machine"
}

variable "data-disks" {
  type = list(object({
    name         = string
    storage-type = string
    tier         = optional(string)
    size-gb      = number
  }))
  default     = null
  description = "list of data disks to be attached to the virtual machine"
}

variable "source-image-id" {
  type        = string
  default     = null
  description = "value for the resource id of the image to be used for the virtual machine. Link to the list of available images: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage"
}

variable "image-sku" {
  type        = string
  default     = "2022-datacenter-azure-edition"
  description = "value for the sku of the image to be used for the virtual machine. Link to the list of available images: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage"
}

variable "image-publisher" {
  type        = string
  default     = "MicrosoftWindowsServer"
  description = "value for the publisher of the image to be used for the virtual machine. Link to the list of available images: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage"
}

variable "image-offer" {
  type        = string
  default     = "WindowsServer"
  description = "value for the offer of the image to be used for the virtual machine. Link to the list of available images: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage"
}

variable "image-version" {
  type        = string
  default     = "latest"
  description = "value for the version of the image to be used for the virtual machine. Link to the list of available images: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage"
}

variable "license_type" {
  type        = string
  default     = "Windows_Server"
  description = "value for the license type of the virtual machine. Link to the list of available license types: https://docs.microsoft.com/en-us/azure/virtual-machines/windows/cli-ps-findimage"
}

variable "support-hvic" {
  type        = bool
  default     = true
  description = "Determines if secure boot and vTPM are enabled on the virtual machine. This is only available for certain VM sizes. Link to the list of available sizes: https://docs.microsoft.com/en-us/azure/virtual-machines/sizes-general"
}

variable "update-management-integration" {
  type        = bool
  default     = true
  description = "Determines if the virtual machine should be integrated with Azure Update Management with periodic scanning"
}

variable "disk-encryption" {
  type = object({
    key-vault-url            = string
    key-vault-encryption-url = string
    key-vault-resource-id    = string
  })
  default     = null
  description = "values used to enable Azure Disk Encryption. These are passed to the vm extension. The encryption url is the url to the encryption key. Make sure that the keyvault allows access for azure vms to connect to it and download the key"
}

variable "global-tags" {
  type        = map(string)
  default     = {}
  description = "tags to be applied to all resources"
}

variable "enable-azuread-login" {
  type        = bool
  default     = true
  description = "value to determine if the virtual machine should be enabled for azure ad login"
}

variable "availability_set_id" {
  type    = string
  default = null
}

variable "machine-index" {
  type    = number
  default = null
}

variable "plan" {
  type = object({
    name      = string
    publisher = string
    product   = string
  })
  default = null
}
