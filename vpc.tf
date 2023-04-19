data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name  = "german-vpc"
    Owner = "german"
  }
}

resource "aws_subnet" "public_1" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name  = "german-public"
    Owner = "german"
    Tier  = "public"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name  = "german-public"
    Owner = "german"
    Tier  = "public"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name  = "german-main"
    Owner = "german"
  }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.rt_igw.id
}

resource "aws_route_table_association" "public_b" {
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
    Owner = "german"
  }
}

resource "aws_nat_gateway" "ngw_a" {
  connectivity_type = "public"
  allocation_id     = aws_eip.a.id
  subnet_id         = aws_subnet.public_1.id

  tags = {
    Owner = "german"
    Name  = "german-ngw"
  }
}

resource "aws_nat_gateway" "ngw_b" {
  connectivity_type = "public"
  allocation_id     = aws_eip.b.id
  subnet_id         = aws_subnet.public_2.id

  tags = {
    Owner = "german"
    Name  = "german-ngw"
  }
}

resource "aws_eip" "a" {
  vpc = true
}

resource "aws_eip" "b" {
  vpc = true
}
