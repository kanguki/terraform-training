resource "docker_container" "nodered" {
  name  = var.name_in
  image = var.image_in
  ports {
    internal = "1880"
  }
  volumes {
    container_path = "/data"
    volume_name = docker_volume.nodered_volume.name
  }
}

resource "docker_volume" "nodered_volume" {
  name = "${var.name_in}_volume"
  lifecycle {
    prevent_destroy = false
  }
}