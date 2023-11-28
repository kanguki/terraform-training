output "name_out" {
    value = docker_container.nodered.name
}
output "address_out" {
    value = join(":", docker_container.nodered.ports[*].ip, docker_container.nodered.ports[*].external)
}