variable "resource_group_name" {
  type=string
}

variable "location" {
  type=string
}

variable "nsg_id" {
  type=string
}

variable "windows-admin-username" {
  type        = string
  description = "Windows VM Admin User"
  default     = "tfadmin"
}

variable "windows-admin-password" {
  type        = string
  description = "Windows VM Admin Password"
}

variable "windows-vm-hostname" {
  type        = string
  description = "Windows VM Hostname"
  default     = "tfazurevm1"
}

variable "windows-vm-size" {
  type        = string
  description = "Windows VM Size"
  default     = "Standard_B2s"
}

variable "windows-2019-sku" {
  type        = string
  description = "Windows Server 2019 SKU used to build VMs"
  default     = "2019-Datacenter"
}