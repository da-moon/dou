module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.59.0"

  name = "${var.project_name}-vpc"
  cidr = var.cidr_block

  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  enable_nat_gateway = false
  enable_vpn_gateway = false

  tags = {
    "Name"                                      = var.project_name
    "kubernetes.io/cluster/${var.cluster-name}" = "shared"
  }
}


# Internet Gateway for Public Subnet
resource "aws_internet_gateway" "ig" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "plm-ig"
  }
}


# Elastic-IP (eip) for NAT
resource "aws_eip" "nat_eip" {
  vpc = true
}


# NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.plm_public.*.id, 0)

  tags = {
    Name = "nat"
  }
}


## Public Subnet Configuration
resource "aws_subnet" "plm_public" {
  count                   = length(var.public_subnets)
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = element(var.public_subnets, count.index)
  map_public_ip_on_launch = "true"
  availability_zone       = var.azs_publics[count.index]
  #availability_zone      = element(var.availability_zones, count.index)

  tags = {
    Name = element(var.public_subnets_name, count.index)
  }
}


## Private Subnet 
resource "aws_subnet" "plm_private" {
  count             = length(var.private_subnets)
  vpc_id            = module.vpc.vpc_id
  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = var.azs_privates[count.index]

  #map_public_ip_on_launch = "false"
  tags = {
    Name = element(var.private_subnets_name, count.index)
  }
}


# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "plm-route-tbl-private"
  }
}


# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "plm-route-tbl-public"
  }
}


# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {

  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}


# Route for NAT
resource "aws_route" "private_nat_gateway" {
  #route_table_id        = element(aws_route_table.private[*].id, count.index)
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}


# Route table associations for both Public & Private Subnets
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.plm_public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.plm_private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}


# Default Security Group of VPC
resource "aws_security_group" "default" {
  name        = "vpc-sg"
  description = "Default SG to alllow traffic from the VPC"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

  tags = {
    Name = "vpc-sg"
  }
}