output "app_access" {
  value = { for k, v in module.container : k => v.address_out }
}
