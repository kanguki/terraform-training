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

resource "docker_container" "alpine_test_import" {
    name = "fixed_if_run_terraform_apply_afterwards"
    image = "alpine:3"
    ports {
        internal = "8000"
        external = "8000"
    }
    command = [
        "tail",
        "-f",
        "/dev/null"
    ]
}
