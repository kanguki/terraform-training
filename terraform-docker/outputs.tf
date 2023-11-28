output nodered_container_whole_names {
    value = docker_container.nodered[*].name
}
output nodered_container_external_address {
    value = [for c in docker_container.nodered[*]: join(":", c.ports[*].ip, c.ports[*].external)] 
}