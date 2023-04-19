resource "aws_route_table" "xport-public-crt" {
  vpc_id = aws_vpc.xportVPC.id

  route {
    //associated subnet can reach everywhere
    cidr_block = "0.0.0.0/0"
    //CRT uses this IGW to reach internet
    gateway_id = aws_internet_gateway.xport-igw.id
  }

  tags = {
    Name = "${var.project_name}-public-crt"
  }
}

resource "aws_route_table_association" "xport-crta-public-subnet-1" {
  subnet_id      = aws_subnet.xport-subnet-public-1.id
  route_table_id = aws_route_table.xport-public-crt.id
}
