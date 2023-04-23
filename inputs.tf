variable "resource-group-name" {
  type = string
}

variable "location" {
  type    = string
  default = "switzerlandnorth"
}

variable "project-name" {
  type        = string
  description = "this is used as the main part of the resource name"
}

variable "resource-prefixes" {
  type        = list(string)
  description = "these are prefixed to resource names and usually include the tenant short name and/or the environment name"

  default = []
}

variable "computer-name" {
  type = string
  default = null
}

variable "subnet-id" {
  type = string
}

variable "ip-address" {
  type = string
  default = null
}

variable "vm-size" {
  type    = string
  default = "Standard_D2s_V2"
}

variable "data-disks" {
  type = list(object({
    name         = string
    storage-type = string
    tier         = optional(string)
    size-gb      = number
  }))
  default = null
}

variable "image-sku" {
  type    = string
  default = "2022-datacenter-azure-edition"
}

variable "image-publisher" {
  type    = string
  default = "MicrosoftWindowsServer"
}

variable "image-offer" {
  type    = string
  default = "WindowsServer"
}

variable "image-version" {
  type    = string
  default = "latest"
}

variable "support-hvic" {
  type    = bool
  default = true
}

variable "update-management-integration" {
  type    = bool
  default = true
}

variable "disk-encryption" {
  type = object({
    key-vault-url            = string
    key-vault-encryption-url = string
    key-vault-resource-id    = string
  })
  default = null
}

variable "global-tags" {
  type = map(string)
  default = {}
}

variable "enable-azuread-login" {
  type = bool
  default = true
}