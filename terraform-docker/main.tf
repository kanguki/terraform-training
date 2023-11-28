module "image" {
  source = "./image"
  image_name = var.container_image[terraform.workspace]
}

resource "random_string" "random" {
  count   = var.num
  length  = 4
  special = false
  upper   = false
}

module "container" {
  source = "./container"
  count = var.num
  name_in  = join("-", [lookup(var.container_prefix, var.env), "nodered", random_string.random[count.index].result])
  image_in = module.image.image_id
}