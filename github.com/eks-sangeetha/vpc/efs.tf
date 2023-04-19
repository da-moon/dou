resource "aws_efs_file_system" "fs" {
  encrypted = true

  tags = {
    Name = "eks-efs"
  }
}


resource "aws_security_group" "efs" {
  name        = "efs"
  description = "Communication to efs"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "efs"
  }
}


resource "aws_efs_mount_target" "efs_mount" {
  file_system_id  = aws_efs_file_system.fs.id
  subnet_id       = aws_subnet.public_1.id
  security_groups = [aws_security_group.efs.id]
}