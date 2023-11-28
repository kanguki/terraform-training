output "nodered_container_whole_names" {
  value = module.container[*].name_out
}
output "nodered_container_external_address" {
  value = module.container[*].address_out
}