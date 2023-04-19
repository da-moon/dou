output "id" {
  description = "EFS created ID"
  value       = var.create_efs ? aws_efs_file_system.main.*.id : []
}

output "dns_name" {
  description = "EFS DNS Name"
  value       = var.create_efs ? aws_efs_file_system.main.*.dns_name : []
}
