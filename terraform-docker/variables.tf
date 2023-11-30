
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

variable "container_image" {
  type = map(map(string))
  default = {
    dev = {
      nodered  = "nodered/node-red:latest"
      influxdb = "quay.io/influxdb/influxdb:v2.0.2"
    }
    prod = {
      nodered  = "nodered/node-red:latest-minimal"
      influxdb = "quay.io/influxdb/influxdb:v2.0.2"
    }
  }
}
