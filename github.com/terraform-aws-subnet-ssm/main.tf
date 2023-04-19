resource "aws_subnet" "subnet" {
  vpc_id          = var.vpc_id
  cidr_block      = var.cidr_block
  ipv6_cidr_block = var.ipv6_cidr_block

  availability_zone    = var.availability_zone
  availability_zone_id = var.availability_zone_id

  assign_ipv6_address_on_creation = var.assign_ipv6_address_on_creation
  map_public_ip_on_launch         = var.allow_public_ip

  # map_customer_owned_ip_on_launch = var.customer_owned_ip
  # customer_owned_ipv4_pool        = var.customer_owned_ipv4_pool
  # outpost_arn                     = var.outpost_arn

  tags = var.tags
}