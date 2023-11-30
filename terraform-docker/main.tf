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
  internal_port_in = each.value.internal_port_in
}

