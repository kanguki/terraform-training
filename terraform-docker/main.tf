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

resource "docker_container" "nodered" {
    name = "nodered_test"
    image = docker_image.nodered.image_id
    ports {
        internal = "1880"
        external = "1880"
    }
}
