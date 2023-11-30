resource "random_string" "random" {
  count = var.count_in
  length   = 4
  special  = false
  upper    = false
}

resource "docker_container" "container" {
  count = var.count_in
  name  = join("-", [var.name_in, random_string.random[count.index].result])
  image = var.image_in
  ports {
    internal = "1880"
  }
  volumes {
    container_path = "/data"
    volume_name = docker_volume.volume.name
  }
}

resource "docker_volume" "volume" {
  name = "${var.name_in}_volume"
  lifecycle {
    prevent_destroy = false
  }
}