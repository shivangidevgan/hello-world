variable "resource_group_name" {
  type=string
}

variable "location" {
  type=string
}

variable "path" {
  type = string
  default = "${path.module}/cloudconfig.tpl"
}
variable "subnet_id" {
  type = string
}