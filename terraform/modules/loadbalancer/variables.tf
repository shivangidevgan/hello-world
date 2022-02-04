variable "resource_group_name" {
  type=string
}

variable "location" {
  type=string
}

variable "path" {
  type = string
  default = "packer/cloudconfig.tpl"
}