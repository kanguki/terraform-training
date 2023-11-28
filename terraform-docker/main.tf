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

resource "null_resource" "dockervol" {
  provisioner "local-exec" {
    command = "mkdir -p noderedvol"
  }
}

resource "docker_container" "nodered" {
  depends_on = [ null_resource.dockervol ]
  count = var.num
  name  = join("-", [lookup(var.container_prefix, var.env), "nodered", random_string.random[count.index].result])
  image = module.image.image_id
  ports {
    internal = "1880"
  }
  volumes {
    container_path = "/data"
    host_path = "${path.cwd}/noderedvol"
  }
}
