
resource "aws_efs_file_system" "deployment_center" {
  encrypted = true

  tags = {
    Application = "Teamcenter"
    Name        = "${local.prefix}-deployment-center"
  }
}

resource "aws_security_group" "efs" {
  name        = "${local.prefix}-deployment-center-efs"
  description = "Security group attached to EFS of Deployment Center"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description      = "NFS from deployment center instances"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    cidr_blocks      =  [data.aws_vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name  = "${local.prefix}-deployment-center-efs"
  }
}

resource "aws_efs_mount_target" "mount_a" {
  file_system_id  = aws_efs_file_system.deployment_center.id
  subnet_id       = var.instance_subnets[0]
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_mount_target" "mount_b" {
  file_system_id  = aws_efs_file_system.deployment_center.id
  subnet_id       = var.instance_subnets[1]
  security_groups = [aws_security_group.efs.id]
}

