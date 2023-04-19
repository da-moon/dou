resource "aws_internet_gateway" "xport-igw" {
  vpc_id = aws_vpc.xportVPC.id
  tags = {
    Name = "${var.project_name}-igw"
  }
}
