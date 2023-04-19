data "aws_subnet" "public_subnet_1" {
  id = var.public_subnet_ids[0]
}

data "aws_subnet" "public_subnet_2" {
  id = var.public_subnet_ids[1]
}

data "aws_vpc" "main" {
  id = var.vpc_id
}

resource "aws_efs_file_system" "fs" {
  encrypted = true

  tags = {
    Application = "Teamcenter"
    Name = "${var.prefix_name}-${var.fs_service}"
    Env = "${var.env_name}"
  }
}

resource "aws_security_group" "efs" {
  name        = "${var.prefix_name}-${var.fs_service}efs-sg"
  description = "Security group attached to EFS"
  vpc_id      = var.vpc_id

  ingress {
    description      = "NFS from build server instances"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks  =  [data.aws_vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name  = "${var.prefix_name}-${var.fs_service}-efs-sg"
  }
}
