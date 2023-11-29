output "nodered_container_whole_names" {
  value = module.container_nodered[*].name_out
}
output "nodered_container_external_address" {
  value = module.container_nodered[*].address_out
}