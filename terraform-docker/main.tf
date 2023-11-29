locals {
  nodered  = "nodered"
  influxdb = "influxdb"
}

resource "random_string" "random" {
  count   = var.num
  length  = 4
  special = false
  upper   = false
}

module "image_nodered" {
  source     = "./image"
  image_name = var.container_image[local.nodered][terraform.workspace]
}

module "container_nodered" {
  source   = "./container"
  count    = var.num
  name_in  = join("-", [lookup(var.container_prefix, var.env), local.nodered, random_string.random[count.index].result])
  image_in = module.image_nodered.image_id
}

module "image_influxdb" {
  source     = "./image"
  image_name = var.container_image[local.influxdb][terraform.workspace]
}

