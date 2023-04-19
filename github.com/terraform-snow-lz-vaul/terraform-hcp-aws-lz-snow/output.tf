output "vpc_cidr" {
  value       = aws_vpc.main_vpc.cidr_block
  description = "CIDR Block of the main VPC"
}

output "transit_gw" {
  value       = aws_ec2_transit_gateway.tgw.id
  description = "Transit Gateway ID"
}

output "resource_share_arn" {
  value       = aws_ram_resource_share.ram.arn
  description = "Resource Share ARN that was generated"
}

output "main_subnet" {
  value       = aws_subnet.main_subnet.id
  description = "ID for the main subnet that was provisioned"
}

output "tfc_agent_sg" {
  value       = aws_security_group.tfc_isolated.id
  description = "ID for the TFC Agent Security Group"
}
