resource "aws_subnet" "xport-subnet-public-1" {
  vpc_id                  = aws_vpc.xportVPC.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true" //it makes this a public subnet2
  availability_zone       = var.avz
  tags = {
    Name = "${var.project_name}subnet-public-1"
  }
}
