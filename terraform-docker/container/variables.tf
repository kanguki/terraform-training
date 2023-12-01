variable "name_in" {
  type        = string
  description = "name of the docker container"
}

variable "image_in" {
  type        = string
  description = "name of the docker image"
}

variable "count_in" {
  type        = number
  description = "number of containers to create"
}

variable "internal_data_in" {
  type        = string
  description = "path in docker container you want to make a volume for"
}

variable "internal_port_in" {
  type        = number
  description = "internal port that needs to expose"
}