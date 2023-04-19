# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# code: language=terraform insertSpaces=true tabSize=2

#
# ──── AWS_VPC RESOURCE ──────────────────────────────────────────────
#
output "arn" {
  depends_on  = [aws_vpc.this]
  value       = aws_vpc.this.arn
  description = <<EOT
  Amazon Resource Name (ARN) of VPC
  EOT
}
output "id" {
  depends_on  = [aws_vpc.this]
  value       = aws_vpc.this.id
  description = <<EOT
  The ID of the VPC
  EOT
}
output "cidr_block" {
  depends_on  = [aws_vpc.this]
  value       = aws_vpc.this.cidr_block
  description = <<EOT
  The IPv4 CIDR block for the VPC.
  EOT
}
output "instance_tenancy" {
  depends_on  = [aws_vpc.this]
  value       = aws_vpc.this.instance_tenancy
  description = <<EOT
  Tenancy of instances spin up within VPC.
  EOT
}
output "enable_dns_support" {
  depends_on  = [aws_vpc.this]
  value       = aws_vpc.this.enable_dns_support
  description = <<EOT
  Whether or not the VPC has DNS support
  EOT
}
output "enable_dns_hostnames" {
  depends_on  = [aws_vpc.this]
  value       = aws_vpc.this.enable_dns_hostnames
  description = <<EOT
  Whether or not the VPC has DNS hostname support
  EOT
}
output "enable_classiclink" {
  depends_on  = [aws_vpc.this]
  value       = aws_vpc.this.enable_classiclink
  description = <<EOT
  Whether or not the VPC has Classiclink enabled
  EOT
}
output "main_route_table_id" {
  depends_on  = [aws_vpc.this]
  value       = aws_vpc.this.main_route_table_id
  description = <<EOT
  The ID of the main route table associated with this VPC.
  EOT
}
output "default_network_acl_id" {
  depends_on  = [aws_vpc.this]
  value       = aws_vpc.this.default_network_acl_id
  description = <<EOT
  The ID of the network ACL created by default on VPC creation
  EOT
}
output "default_security_group_id" {
  depends_on  = [aws_vpc.this]
  value       = aws_vpc.this.default_security_group_id
  description = <<EOT
  The ID of the security group created by default on VPC creation
  EOT
}
output "default_route_table_id" {
  depends_on  = [aws_vpc.this]
  value       = aws_vpc.this.default_route_table_id
  description = <<EOT
  The ID of the route table created by default on VPC creation
  EOT
}
output "ipv6_association_id" {
  depends_on  = [aws_vpc.this]
  value       = aws_vpc.this.ipv6_association_id
  description = <<EOT
  The association ID for the IPv6 CIDR block.
  EOT
}
output "ipv6_cidr_block" {
  depends_on  = [aws_vpc.this]
  value       = aws_vpc.this.ipv6_cidr_block
  description = <<EOT
  The Network Border Group Zone name
  EOT
}
output "owner_id" {
  depends_on  = [aws_vpc.this]
  value       = aws_vpc.this.owner_id
  description = <<EOT
  The ID of the AWS account that owns the VPC.
  EOT
}
output "tags_all" {
  depends_on  = [aws_vpc.this]
  value       = aws_vpc.this.tags_all
  description = <<EOT
  A map of tags assigned to the resource, including those inherited from the
  provider `default_tags` configuration block.
  EOT
}
#
# ──── AWS_SUBNET RESOURCE ────────────────────────────────────────────
#
output "public_subnet_id" {
  depends_on = [aws_subnet.public, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_subnet.public.*, idx).id
  }
  description = <<EOT
  The ID of the subnet
  EOT
}
output "public_subnet_arn" {
  depends_on = [aws_subnet.public, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_subnet.public.*, idx).arn
  }
  description = <<EOT
  The ARN of the subnet.
  EOT
}
output "public_subnet_ipv6_cidr_block_association_id" {
  depends_on = [aws_subnet.public, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_subnet.public.*, idx).ipv6_cidr_block_association_id
  }
  description = <<EOT
  The association ID for the IPv6 CIDR block.
  EOT
}
output "public_subnet_owner_id" {
  depends_on = [aws_subnet.public, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_subnet.public.*, idx).owner_id
  }
  description = <<EOT
  The ID of the AWS account that owns the subnet.
  EOT
}
output "public_subnet_tags_all" {
  depends_on = [aws_subnet.public, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_subnet.public.*, idx).tags_all
  }
  description = <<EOT
  A map of tags assigned to the resource, including those inherited from the
  provider `default_tags` configuration block.
  EOT
}
output "private_subnet_id" {
  depends_on = [aws_subnet.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_subnet.private.*, idx).id
  }
  description = <<EOT
  The ID of the subnet
  EOT
}
output "private_subnet_arn" {
  depends_on = [aws_subnet.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_subnet.private.*, idx).arn
  }
  description = <<EOT
  The ARN of the subnet.
  EOT
}
output "private_subnet_ipv6_cidr_block_association_id" {
  depends_on = [aws_subnet.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_subnet.private.*, idx).ipv6_cidr_block_association_id
  }
  description = <<EOT
  The association ID for the IPv6 CIDR block.
  EOT
}
output "private_subnet_owner_id" {
  depends_on = [aws_subnet.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_subnet.private.*, idx).owner_id
  }
  description = <<EOT
  The ID of the AWS account that owns the subnet.
  EOT
}
output "private_subnet_tags_all" {
  depends_on = [aws_subnet.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_subnet.private.*, idx).tags_all
  }
  description = <<EOT
  A map of tags assigned to the resource, including those inherited from the
  provider `default_tags` configuration block.
  EOT
}
#
# ──── AWS_INTERNET_GATEWAY RESOURCE ──────────────────────────────────
#
output "internet_gateway_id" {
  depends_on  = [aws_internet_gateway.public]
  value       = aws_internet_gateway.public.id
  description = <<EOT
  The ID of the Internet Gateway.
  EOT
}
output "internet_gateway_arn" {
  depends_on  = [aws_internet_gateway.public]
  value       = aws_internet_gateway.public.arn
  description = <<EOT
  The ARN of the Internet Gateway.
  EOT
}
output "internet_gateway_owner_id" {
  depends_on  = [aws_internet_gateway.public]
  value       = aws_internet_gateway.public.owner_id
  description = <<EOT
  The ID of the AWS account that owns the internet gateway.
  EOT
}
output "internet_gateway_tags_all" {
  depends_on  = [aws_internet_gateway.public]
  value       = aws_internet_gateway.public.tags_all
  description = <<EOT
  A map of tags assigned to the resource, including those inherited from the
  provider `default_tags` configuration block.
  EOT
}
#
# ──── AWS_ROUTE RESOURCE ────────────────────────────────────────────
#
output "public_route_id" {
  depends_on  = [aws_route.public]
  value       = aws_route.public.id
  description = <<EOT
  Route identifier computed from the routing table identifier and route
  destination.
  EOT
}
output "public_route_instance_owner_id" {
  depends_on  = [aws_route.public]
  value       = aws_route.public.instance_owner_id
  description = <<EOT
  The AWS account ID of the owner of the EC2 instance.
  EOT
}
output "public_route_origin" {
  depends_on  = [aws_route.public]
  value       = aws_route.public.origin
  description = <<EOT
  How the route was created - `CreateRouteTable`, `CreateRoute` or
  `EnableVgwRoutePropagation`.
  EOT
}
output "public_route_state" {
  depends_on  = [aws_route.public]
  value       = aws_route.public.state
  description = <<EOT
  The state of the route - `active` or `blackhole`.
  EOT
}
#
# ──── AWS_EIP RESOURCE ──────────────────────────────────────────────
#
output "nat_gateway_eip_allocation_id" {
  depends_on = [aws_eip.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_eip.private.*, idx).allocation_id
  }
  description = <<EOT
  ID that AWS assigns to represent the allocation of the Elastic IP address for
  use with instances in a VPC.
  EOT
}
output "nat_gateway_eip_association_id" {
  depends_on = [aws_eip.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_eip.private.*, idx).association_id
  }
  description = <<EOT
  ID representing the association of the address with an instance in a VPC.
  EOT
}
output "nat_gateway_eip_carrier_ip" {
  depends_on = [aws_eip.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_eip.private.*, idx).carrier_ip
  }
  description = <<EOT
  Carrier IP address.
  EOT
}
output "nat_gateway_eip_customer_owned_ip" {
  depends_on = [aws_eip.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_eip.private.*, idx).customer_owned_ip
  }
  description = <<EOT
  Customer owned IP.
  EOT
}
output "nat_gateway_eip_domain" {
  depends_on = [aws_eip.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_eip.private.*, idx).domain
  }
  description = <<EOT
  Indicates if this EIP is for use in VPC (`vpc`) or EC2 Classic (`standard`).
  EOT
}
output "nat_gateway_eip_id" {
  depends_on = [aws_eip.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_eip.private.*, idx).id
  }
  description = <<EOT
  Contains the EIP allocation ID.
  EOT
}
output "nat_gateway_eip_private_dns" {
  depends_on = [aws_eip.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_eip.private.*, idx).private_dns
  }
  description = <<EOT
  The Private DNS associated with the Elastic IP address (if in VPC).
  EOT
}
output "nat_gateway_eip_private_ip" {
  depends_on = [aws_eip.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_eip.private.*, idx).private_ip
  }
  description = <<EOT
  Contains the private IP address (if in VPC).
  EOT
}
output "nat_gateway_eip_public_dns" {
  depends_on = [aws_eip.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_eip.private.*, idx).public_dns
  }
  description = <<EOT
  Public DNS associated with the Elastic IP address.
  EOT
}
output "nat_gateway_eip_public_ip" {
  depends_on = [aws_eip.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_eip.private.*, idx).public_ip
  }
  description = <<EOT
  Contains the public IP address.
  EOT
}
output "nat_gateway_eip_tags_all" {
  depends_on = [aws_eip.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_eip.private.*, idx).tags_all
  }
  description = <<EOT
  A map of tags assigned to the resource, including those inherited from the
  provider `default_tags` configuration block.
  EOT
}
#
# ──── AWS_NAT_GATEWAY RESOURCE ──────────────────────────────────────
#
output "nat_gateway_id" {
  depends_on = [aws_nat_gateway.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_nat_gateway.private.*, idx).id
  }
  description = <<EOT
  The ID of the NAT Gateway.
  EOT
}
output "nat_gateway_allocation_id" {
  depends_on = [aws_nat_gateway.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_nat_gateway.private.*, idx).allocation_id
  }
  description = <<EOT
  The Allocation ID of the Elastic IP address for the gateway.
  EOT
}
output "nat_gateway_subnet_id" {
  depends_on = [aws_nat_gateway.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_nat_gateway.private.*, idx).subnet_id
  }
  description = <<EOT
  The Subnet ID of the subnet in which the NAT gateway is placed.
  EOT
}
output "nat_gateway_network_interface_id" {
  depends_on = [aws_nat_gateway.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_nat_gateway.private.*, idx).network_interface_id
  }
  description = <<EOT
  The ENI ID of the network interface created by the NAT gateway.
  EOT
}
output "nat_gateway_private_ip" {
  depends_on = [aws_nat_gateway.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_nat_gateway.private.*, idx).private_ip
  }
  description = <<EOT
  The private IP address of the NAT Gateway.
  EOT
}
output "nat_gateway_public_ip" {
  depends_on = [aws_nat_gateway.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_nat_gateway.private.*, idx).public_ip
  }
  description = <<EOT
  The public IP address of the NAT Gateway.
  EOT
}
output "nat_gateway_tags_all" {
  depends_on = [aws_nat_gateway.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_nat_gateway.private.*, idx).tags_all
  }
  description = <<EOT
  A map of tags assigned to the resource, including those inherited from the
  provider `default_tags` configuration block.
  EOT
}
#
# ──── AWS_ROUTE_TABLE RESOURCE ──────────────────────────────────────
#
output "route_table_id" {
  depends_on = [aws_route_table.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_route_table.private.*, idx).id
  }
  description = <<EOT
  The ID of the routing table.
  EOT
}
output "route_table_arn" {
  depends_on = [aws_route_table.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_route_table.private.*, idx).arn
  }
  description = <<EOT
  The ARN of the route table.
  EOT
}
output "route_table_tags_all" {
  depends_on = [aws_route_table.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_route_table.private.*, idx).tags_all
  }
  description = <<EOT
  A map of tags assigned to the resource, including those inherited from the
  provider `default_tags` configuration block.
  EOT
}
#
# ──── AWS_ROUTE_TABLE_ASSOCIATION RESOURCE ──────────────────────────
#
output "route_table_association_id" {
  depends_on = [aws_route_table_association.private, data.aws_availability_zones.this]
  value = {
    for idx, value in data.aws_availability_zones.this.names : value => element(aws_route_table_association.private.*, idx).id
  }
  description = <<EOT
  The ID of the association
  EOT
}
