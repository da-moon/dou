resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "eks-manual"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name        = "eks-manual-public-1"

  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name        = "eks-manual-public-2"

  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "eks-manual"

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
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "eks-manual"

  }
}

resource "aws_nat_gateway" "ngw_1" {
  connectivity_type = "public"
  allocation_id     = aws_eip.a.id
  subnet_id         = aws_subnet.public_1.id

  tags = {
    Name        = "eks-manual-ngw-1"

  }
}

resource "aws_nat_gateway" "ngw_2" {
  connectivity_type = "public"
  allocation_id     = aws_eip.b.id
  subnet_id         = aws_subnet.public_2.id

  tags = {
    Name        = "eks-manual-ngw-2"
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
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.10.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "eks-manual-private-build-1"
  }
}

resource "aws_subnet" "build_server_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "eks-manual-private-build-2"
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
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw_1.id
  }
}

resource "aws_route_table" "rt_ngw_b" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw_2.id
  }
}

