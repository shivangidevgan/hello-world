variable "resource_group_name" {
  type=string
}

variable "location" {
  type=string
}

variable "path" {
  type = string
  default = "D:/Assignment/hello-world/terraform/modules/vm_CloudInit/cloudconfig.tpl"
}

variable "subnet_id" {
  type = string
}

variable "lbid" {
  type = string
}