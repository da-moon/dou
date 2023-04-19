resource "aws_security_group" "node_group_one" {
  name_prefix = "node_group_one"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = [
      cidrsubnet(data.aws_vpc.main.cidr_block, 4, 1),
    ]
  }
}

