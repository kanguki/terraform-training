variable "vpc_cidr" {
  type        = string
  description = "cidr_block of the vpc"
}

variable "public_subnets" {
  type = list(object({
    cidr = string
    az   = string
    tags = optional(map(string))
  }))
  description = "information to create public subnets: cidr blocks, availability zones"
}

variable "private_subnets" {
  type = list(object({
    cidr = string
    az   = string
    tags = optional(map(string))
  }))
  description = "information to create private subnets: cidr blocks, availability zones"
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "system_name" {
  type        = string
  description = "name of the system that this network runs on, used as prefix of resources' names in this network"
}