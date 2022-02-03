variable "public_key" {
  type = string
  default = "ssh-rsa key"
}

variable "template" {
  type = string
  default = "Debian GNU/Linux 10 (Buster)"
}

variable "app-scaling" {
  default = 3
}
variable "plans" {
  type = map
  default = {
    "lb"  = "1xCPU-2GB"
    "app" = "2xCPU-4GB"     
    "db"  = "4xCPU-8GB"
  }
}

variable "storages" {
  type = map
  default = {
    "1xCPU-2GB"  = "50"
    "2xCPU-4GB"  = "80"
    "4xCPU-8GB"  = "160"
    "6xCPU-16GB" = "320"
  }
}

variable "zone" {
  type = string
  default = "pl-waw1"
}