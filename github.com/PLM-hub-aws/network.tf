# Getting eip from the eip folder
data "aws_eip" "licenseip" {
  id = "eipalloc-0b545b5563e96e30a"
}

# Configure VPC Creation Module
# https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws/2.44.0
module "vpc" {
  source           = "terraform-aws-modules/vpc/aws"
  version          = "2.44.0"
  name             = var.project_name
  cidr             = var.cidr_block
  create_igw       = false
  instance_tenancy = var.instance_tenancy

  #azs                  = [var.azs_public]
  enable_nat_gateway   = false
  enable_vpn_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    name = var.project_name
  }
}

resource "aws_security_group" "security_group" {
  name        = var.project_name
  description = "Security group for ${var.project_name}"
  vpc_id      = module.vpc.vpc_id
  ingress {
    description = "SSH from Bastian"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "HTTP for EC2"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name    = "${var.project_name}-sg"
    Project = var.project_name
  }
}

#Create public subnet
resource "aws_subnet" "public_subnet" {
  count             = length(var.public_subnet)
  vpc_id            = module.vpc.vpc_id
  cidr_block        = var.public_subnet[count.index]
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name = element(var.public_subnet_name, count.index)
  }
}

#Create private subnet
resource "aws_subnet" "private_subnet" {
  count                   = length(var.private_subnet)
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.private_subnet[count.index]
  availability_zone       = var.azs_private[count.index]
  map_public_ip_on_launch = "false"

  tags = {
    Name = element(var.private_subnet_name, count.index)
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "teamcenter-ig" {
  vpc_id = module.vpc.vpc_id
  tags = {
    Name = "${var.project_name}-igw"
  }
}

# Elastic-IP (eip) for NAT
resource "aws_eip" "nat_eip" {
  vpc = true
}

# NAT
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)

  tags = {
    Name = "nat"
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
  gateway_id             = aws_internet_gateway.teamcenter-ig.id
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
  count          = length(var.public_subnet)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnet)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

# Elastic-IP (eip) for Web public ip and Deployment center public ip
resource "aws_eip" "web_eip" {
  count = 2
  vpc = true
}




