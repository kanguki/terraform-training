variable "num" {
  type    = number
  default = 1
}

variable "env" {
  type    = string
  default = "dev"
}

variable "container_prefix" {
  type = map(string)
  default = {
    dev  = "dev"
    prod = "prod"
  }
}
