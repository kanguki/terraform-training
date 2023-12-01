resource "random_string" "random" {
  count   = var.count_in
  length  = 4
  special = false
  upper   = false
}

resource "docker_container" "container" {
  count = var.count_in
  name  = join("-", [var.name_in, random_string.random[count.index].result])
  image = var.image_in
  ports {
    internal = var.internal_port_in
  }
  dynamic "volumes" {
    for_each = var.volumes_in
    content {
      container_path = volumes.value.vol
      volume_name    = docker_volume.volume[volumes.value.name].name
    }
  }
}

resource "docker_volume" "volume" {
  for_each = { for vol in var.volumes_in[*] : vol.name => "" }
  name     = "${var.name_in}_${each.key}_volume"
  lifecycle {
    prevent_destroy = false
  }
}