locals {
  services = {
    nodered = {
    }
    influxdb = {
    }
  }
}
resource "random_string" "random" {
  for_each = local.services
  length   = 4
  special  = false
  upper    = false
}

module "image" {
  source     = "./image"
  for_each   = local.services
  image_name = var.container_image[terraform.workspace][each.key]
}

module "container" {
  source   = "./container"
  for_each = local.services
  name_in  = join("-", [var.container_prefix[terraform.workspace], each.key, random_string.random[each.key].result])
  image_in = module.image[each.key].image_id
}

