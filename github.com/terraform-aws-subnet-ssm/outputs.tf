output "id" {
  description = "The ID of the subnet"
  value       = aws_subnet.subnet.id
}

output "arn" {
  description = "The ARN of the subnet."
  value       = aws_subnet.subnet.arn
}

output "ipv6_association_id" {
  description = "The association ID for the IPv6 CIDR block."
  value       = aws_subnet.subnet.ipv6_cidr_block_association_id
}

output "owner_id" {
  description = "The ID of the AWS account that owns the subnet."
  value       = aws_subnet.subnet.owner_id
}