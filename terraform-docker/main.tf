terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
    host = "unix:///Users/monguyen/.colima/docker.sock"
}

resource "docker_image" "nodered" {
  name = "nodered/node-red:latest"
}
