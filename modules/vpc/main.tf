# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# code: language=terraform insertSpaces=true tabSize=2


# ──── NOTE ──────────────────────────────────────────────────────────
# Fetch Availablity Zones in the current region
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones
# ─────────────────────────────────────────────────────────────────────
data "aws_availability_zones" "this" {}

#
# ──── VPC ────────────────────────────────────────────────────────────
#

# ──── NOTE ──────────────────────────────────────────────────────────
# Creates a VPC
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc
# ─────────────────────────────────────────────────────────────────────
resource "aws_vpc" "this" {
  cidr_block = var.cidr_block
  tags = {
    Name = "${var.project_name}-vpc"
  }
}
#
# ──── PUBLIC SUBNET ──────────────────────────────────────────────────
#

# ──── NOTE ──────────────────────────────────────────────────────────
# Create public subnets, each in a different availablity zone
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# ─────────────────────────────────────────────────────────────────────
resource "aws_subnet" "public" {
  depends_on = [
    aws_vpc.this,
    data.aws_availability_zones.this,
  ]
  count                   = var.availablity_zone_count
  cidr_block              = cidrsubnet(aws_vpc.this.cidr_block, 8, var.availablity_zone_count + count.index)
  availability_zone       = data.aws_availability_zones.this.names[count.index]
  vpc_id                  = aws_vpc.this.id
  map_public_ip_on_launch = true
  tags = {
    Name = "${var.project_name}-public-subnet-${count.index}"
  }
}
# ──── NOTE ──────────────────────────────────────────────────────────
# internet gateway for the public subnet
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway
# ─────────────────────────────────────────────────────────────────────
resource "aws_internet_gateway" "public" {
  depends_on = [
    aws_vpc.this,
  ]
  vpc_id = aws_vpc.this.id
  tags = {
    Name = "${var.project_name}-public-internet-gateway"
  }
}
# ──── NOTE ──────────────────────────────────────────────────────────
# Route the public subnet traffic through the internet gateway
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
# ─────────────────────────────────────────────────────────────────────
resource "aws_route" "public" {
  depends_on = [
    aws_vpc.this,
    aws_internet_gateway.public,
  ]
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_vpc.this.main_route_table_id
  gateway_id             = aws_internet_gateway.public.id
}
#
# ──── PRIVATE SUBNET ────────────────────────────────────────────────
#

# ──── NOTE ──────────────────────────────────────────────────────────
# Create private subnets, each in a different availablity zone
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet
# ─────────────────────────────────────────────────────────────────────
resource "aws_subnet" "private" {
  depends_on = [
    aws_vpc.this,
  ]
  count             = var.availablity_zone_count
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 8, count.index)
  availability_zone = data.aws_availability_zones.this.names[count.index]
  vpc_id            = aws_vpc.this.id
  tags = {
    Name = "${var.project_name}-public-subnet-${count.index}"
  }
}
# ──── NOTE ──────────────────────────────────────────────────────────
# Create a NAT gateway with an elastic IP for
# each private subnet to get internet connectivity
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
# ─────────────────────────────────────────────────────────────────────
resource "aws_eip" "private" {
  depends_on = [
    aws_internet_gateway.public
  ]
  count = var.availablity_zone_count
  vpc   = true
  tags = {
    Name = "${var.project_name}-nat-gateway-elastic-ip-${count.index}"
  }
}
# ──── NOTE ──────────────────────────────────────────────────────────
# Creates a Nat gateway
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway
# ─────────────────────────────────────────────────────────────────────
resource "aws_nat_gateway" "private" {
  depends_on = [
    aws_internet_gateway.public,
    aws_subnet.public,
    aws_eip.private,
  ]
  count         = var.availablity_zone_count
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  allocation_id = element(aws_eip.private.*.id, count.index)
  tags = {
    Name = "${var.project_name}-nat-gateway-${count.index}"
  }
}
# ──── NOTE ──────────────────────────────────────────────────────────
# Create a new route table for the private subnets
# And make it route non-local traffic through the NAT gateway to the internet
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table
# ─────────────────────────────────────────────────────────────────────
resource "aws_route_table" "private" {
  depends_on = [
    aws_vpc.this,
    data.aws_availability_zones.this,
  ]
  count  = var.availablity_zone_count
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.private.*.id, count.index)
  }
  tags = {
    Name = "${var.project_name}-route-table-${count.index}"
  }
}
# ──── NOTE ──────────────────────────────────────────────────────────
# Explicitely associate the newly created route tables to the
# private subnets (so they don't default to the main route table)
# ─────────────────────────────────────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/main_route_table_association
# ─────────────────────────────────────────────────────────────────────
resource "aws_route_table_association" "private" {
  depends_on = [
    aws_vpc.this,
    data.aws_availability_zones.this,
    aws_subnet.private,
    aws_route_table.private,
  ]
  count          = var.availablity_zone_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}
