output "vpc_arn" {
  description = "Amazon Resource Name (ARN) of VPC"
  value       = module.vpc.vpc_arn
}

output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.id
}

output "cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.cidr_block
}

output "owner_id" {
  description = "The ID of the AWS account that owns the VPC."
  value       = module.vpc.owner_id
}

output "ipv6_cidr_block" {
  description = "The IPv6 CIDR block."
  value       = module.vpc.ipv6_cidr_block
}

output "main_route_table_id" {
  description = "The ID of the main route table associated with this VPC. Note that you can change a VPC's main route table by using an aws_main_route_table_association."
  value       = module.vpc.main_route_table_id
}

output "default_security_group_id" {
  description = "The ID of the security group created by default on VPC creation"
  value       = module.vpc.default_security_group_id
}

output "default_route_table_id" {
  description = "The ID of the route table created by default on VPC creation"
  value       = module.vpc.default_route_table_id
}

output "ipv6_association_id" {
  description = "The association ID for the IPv6 CIDR block."
  value       = module.vpc.ipv6_association_id
}

###### SUBNET
output "subnet_id" {
  description = "The IDs of the subnets"
  value       = [for snet in module.subnet : snet.id]
}

output "subnet_arn" {
  description = "The ARN of the subnets."
  value       = [for snet in module.subnet : snet.arn]
}

output "subnet_ipv6_association_id" {
  description = "The association IDs for the IPv6 CIDR block."
  value       = [for snet in module.subnet : snet.ipv6_association_id]
}

##### SECURITY GROUP
output "sg_id" {
  description = "IDs of the security group."
  value       = [for sg in module.security_group : sg.id]
}

output "sg_name" {
  description = "Security Groups Name"
  value       = [for sg in module.security_group : sg.name]
}

output "sg_arn" {
  description = "ARN of the security groups."
  value       = [for sg in module.security_group : sg.arn]
}