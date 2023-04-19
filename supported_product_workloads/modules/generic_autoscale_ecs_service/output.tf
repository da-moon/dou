output "name" {
  value = module.service.name
}

# Do not remove, required for inter-module dependencies.
output "service_name" {
  value = module.service.name
}

output "dns" {
  value = module.lb.dns_record_name
}
