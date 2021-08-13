variable "rg" {
  default = "present-rg"
}

variable "location" {
  default = "australiaeast"
}

variable "vnet_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet_cidr" { 
  default = "10.0.0.0/24"
}

variable "skey" {
  description = "Azure secret key."
}

variable "sshdata" {
  description = "SSH key RSA data."
}

variable "tag" {
  default = "UAT Infrastructure"
}

