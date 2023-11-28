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

resource "docker_container" "nodered" {
  count = var.num
  name  = join("-", [lookup(var.container_prefix, var.env), "nodered", random_string.random[count.index].result])
  image = module.image.image_id
  ports {
    internal = "1880"
  }
}
