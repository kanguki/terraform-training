# output nodered_container_whole {
#     value = docker_container.nodered
# }
# output nodered_container_external_address {
#     value = join(":", [docker_container.nodered.ports[0].ip, docker_container.nodered.ports[0].external])
# }