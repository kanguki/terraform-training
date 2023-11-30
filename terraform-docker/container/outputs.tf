output "name_out" {
    value = docker_container.nodered[*].name
}
output "address_out" {
    value = [for c in docker_container.nodered[*]: join(":", c.ports[*].ip, c.ports[*].external)]
}