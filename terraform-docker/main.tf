terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
    host = "unix://${pathexpand("~/.colima/docker.sock")}"
}

resource "docker_image" "nodered" {
  name = "nodered/node-red:latest"
}

resource "random_string" "random" {
    count = var.num
    length = 4
    special = false
    upper = false
}

resource "docker_container" "nodered" {
    count = var.num
    name = join("-",["nodered", random_string.random[count.index].result])
    image = docker_image.nodered.image_id
    ports {
        internal = "1880"
    }
}
