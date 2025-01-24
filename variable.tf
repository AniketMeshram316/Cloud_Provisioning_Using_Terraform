variable "region" {
  default = "us-east-2"
}

variable "profile" {
  default = "default"
}

variable "vpc_cidr" {
  description = "This is vpc  cidr"
}

variable "public_subnet" {
  description = "This is public subnet cidr"
}

variable "private_subnet" {
  description = "This is public subnet cidr"
}

variable "public_names" {
  description = "Subnet names"
  type        = list(string)
}

variable "private_names" {
  description = "Subnet names"
  type        = list(string)
}