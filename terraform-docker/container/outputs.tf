output "name_out" {
    value = docker_container.container[*].name
}
output "address_out" {
    value = [for c in docker_container.container[*]: join(":", c.ports[*].ip, c.ports[*].external)]
}