locals {
  services_by_env = {
    dev = {
      nodered = {
        image_in         = "nodered/node-red:latest"
        count_in         = 2
        internal_data_in = "/data"
      }
      influxdb = {
        image_in         = "quay.io/influxdb/influxdb:v2.0.2"
        count_in         = 1
        internal_data_in = "/var/lib/influxdb"
      }
    }
    prod = {
      nodered = {
        image_in         = "nodered/node-red:latest-minimal"
        count_in         = 2
        internal_data_in = "/data"
      }
      influxdb = {
        image_in         = "quay.io/influxdb/influxdb:v2.0.2"
        count_in         = 1
        internal_data_in = "/var/lib/influxdb"
      }
    }
  }
  env      = terraform.workspace
  services = local.services_by_env[local.env]
}
module "image" {
  source     = "./image"
  for_each   = local.services
  image_name = each.value.image_in
}

module "container" {
  source           = "./container"
  for_each         = local.services
  count_in         = each.value.count_in
  name_in          = join("-", [local.env, each.key])
  image_in         = module.image[each.key].image_id
  internal_data_in = each.value.internal_data_in
}

