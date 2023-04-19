# Outputs

output "create_vpc" {
  description = "Create VPC"
  value       = local.create_vpc
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main[0].id
}

output "public_subnet_ids" {
  description = "Public Subnet IDs"
  value       = aws_subnet.public.*.id
}

output "private_subnet_ids" {
  description = "Private Subnet IDs"
  value       = local.create_private_subnets ? aws_subnet.private.*.id : []
}