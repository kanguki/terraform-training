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

variable "container_image" {
  type = map(map(string))
  default = {
    nodered = {
      dev  = "nodered/node-red:latest"
      prod = "nodered/node-red:latest-minimal"
    }
    influxdb = {
      dev  = "quay.io/influxdb/influxdb:v2.0.2"
      prod = "quay.io/influxdb/influxdb:v2.0.2"
    }
  }
}
