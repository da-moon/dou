output "id" {
  description = "The ID of the routing table."
  value       = aws_route_table.route_table.id
}

output "arn" {
  description = "The ARN of the route table."
  value       = aws_route_table.route_table.arn
}

output "owner_id" {
  description = "The ID of the AWS account that owns the route table."
  value       = aws_route_table.route_table.owner_id
}

output "association_id_gateway" {
  description = "The ID of the association of gateways"
  value       = aws_route_table_association.assoc_gateway[*].id
}

output "association_id_subnet" {
  description = "The ID of the association of subnets"
  value       = aws_route_table_association.assoc_subnet[*].id
}