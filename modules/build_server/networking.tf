
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_subnet" "private_bs_1" {
  vpc_id            = data.aws_vpc.main.id
  cidr_block        = var.subnet_cidr_1
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name  = "german-build-subnet"
    Owner = "german"
  }
}

resource "aws_subnet" "private_bs_2" {
  vpc_id            = data.aws_vpc.main.id
  cidr_block        = var.subnet_cidr_2
  availability_zone = data.aws_availability_zones.available.names[1]

  tags = {
    Name  = "german-build-subnet"
    Owner = "german"
  }
}

resource "aws_route_table_association" "private_bs_1" {
  subnet_id      = aws_subnet.private_bs_1.id
  route_table_id = aws_route_table.rt_ngw_a.id
}

resource "aws_route_table_association" "private_bs_2" {
  subnet_id      = aws_subnet.private_bs_2.id
  route_table_id = aws_route_table.rt_ngw_b.id
}

resource "aws_route_table" "rt_ngw_a" {
  vpc_id = data.aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id_1
  }

  tags = {
    Owner = "german"
  }
}

resource "aws_route_table" "rt_ngw_b" {
  vpc_id = data.aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = var.nat_gateway_id_2
  }

  tags = {
    Owner = "german"
  }
}

