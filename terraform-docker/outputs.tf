output nodered_container_whole_names {
    value = docker_container.nodered[*].name
}
output nodered_container_external_address {
    value = [for c in docker_container.nodered[*]: "${c.ports[0].ip}:${c.ports[0].external}"] 
}