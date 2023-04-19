data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  count                = var.vpc_id == null ? 1 : 0
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.env_name}"
    Environment = var.env_name
  }
}

resource "aws_subnet" "public_1" {
  vpc_id            = var.vpc_id == null ? aws_vpc.main[0].id : var.vpc_id
  cidr_block        = var.cidr_public_subnets == null ? "10.0.0.0/24" : "${var.cidr_public_subnets[0]}" ###element(var.cidr_public_subnets, 0) 
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name        = "${var.env_name}-public-1"
    Environment = var.env_name
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = var.vpc_id == null ? aws_vpc.main[0].id : var.vpc_id
  cidr_block        = var.cidr_public_subnets == null ? "10.0.1.0/24" : "${var.cidr_public_subnets[1]}" #element(var.cidr_public_subnets, 1)
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name        = "${var.env_name}-public-2"
    Environment = var.env_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = var.vpc_id == null ? aws_vpc.main[0].id : var.vpc_id

  tags = {
    Name        = "${var.env_name}"
    Environment = var.env_name
  }
}

resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.rt_igw.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.rt_igw.id
}

resource "aws_route_table" "rt_igw" {
  vpc_id = var.vpc_id == null ? aws_vpc.main[0].id : var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "${var.env_name}"
    Environment = var.env_name
  }
}

resource "aws_nat_gateway" "ngw_1" {
  connectivity_type = "public"
  allocation_id     = aws_eip.a.id
  subnet_id         = aws_subnet.public_1.id

  tags = {
    Name        = "${var.env_name}-ngw-1"
    Environment = var.env_name
  }
}

resource "aws_nat_gateway" "ngw_2" {
  connectivity_type = "public"
  allocation_id     = aws_eip.b.id
  subnet_id         = aws_subnet.public_2.id

  tags = {
    Name        = "${var.env_name}-ngw-2"
    Environment = var.env_name
  }
}

resource "aws_eip" "a" {
  vpc = true
}

resource "aws_eip" "b" {
  vpc = true
}

resource "aws_eip" "bastion" {
  vpc = true
}

resource "aws_subnet" "build_server_1" {
  vpc_id            = var.vpc_id == null ? aws_vpc.main[0].id : var.vpc_id
  cidr_block        = var.cidr_private_build_subnets == null ? "10.0.10.0/24" : "${var.cidr_private_build_subnets[0]}"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.env_name}-private-build-1"
  }
}

resource "aws_subnet" "build_server_2" {
  vpc_id            = var.vpc_id == null ? aws_vpc.main[0].id : var.vpc_id
  cidr_block        = var.cidr_private_build_subnets == null ? "10.0.11.0/24" : "${var.cidr_private_build_subnets[1]}"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.env_name}-private-build-2"
  }
}

resource "aws_route_table_association" "private_bs_1" {
  subnet_id      = aws_subnet.build_server_1.id
  route_table_id = aws_route_table.rt_ngw_a.id
}

resource "aws_route_table_association" "private_bs_2" {
  subnet_id      = aws_subnet.build_server_2.id
  route_table_id = aws_route_table.rt_ngw_b.id
}

resource "aws_route_table" "rt_ngw_a" {
  vpc_id = var.vpc_id == null ? aws_vpc.main[0].id : var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw_1.id
  }
}

resource "aws_route_table" "rt_ngw_b" {
  vpc_id = var.vpc_id == null ? aws_vpc.main[0].id : var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw_2.id
  }
}

