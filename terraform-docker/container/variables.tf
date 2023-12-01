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

variable "internal_port_in" {
  type        = number
  description = "internal port that needs to expose"
}

variable "volumes_in" {
  type = list(object({
    vol  = string
    name = string
  }))
  description = "path in docker container you want to make a volume for"
}
