output nodered_container_whole_names {
    value = docker_container.nodered[*].name
}
output nodered_container_external_address {
    value = [for k, v in zipmap(docker_container.nodered[*].ports[0].external, docker_container.nodered[*].ports[0].ip): "${k}:${v}"] 
}