locals {
  user_data_vars = {
    efs_id = aws_efs_file_system.fs.id
    region = "us-west-2"
  }
}

resource "aws_launch_configuration" "build_server" {
  name_prefix                 = "german-build-server-"
  image_id                    = var.ami_id
  instance_type               = "t3.xlarge"
  key_name                    = var.key_name
  user_data                   = base64encode(templatefile("./${path.module}/user_data_ubuntu.sh", local.user_data_vars))
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.build_server.arn
  security_groups             = [aws_security_group.build_server.id]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "build_server" {
  name                      = "german-build-server"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = false
  vpc_zone_identifier       = [aws_subnet.private_bs_1.id, aws_subnet.private_bs_2.id]
  launch_configuration      = aws_launch_configuration.build_server.name

  tag {
    key                 = "Owner"
    value               = "german"
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "german-build-server"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "build_server" {
  name        = "german-build-server-sg"
  description = "Security group attached to build server instances"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description      = "SSH from same vpc"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Owner = "german"
    Name  = "german-build-server-sg"
  }
}

resource "aws_security_group" "efs" {
  name        = "german-efs-sg"
  description = "Security group attached to deployment center EFS"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description      = "NFS from deployment center instances"
    from_port        = 2049
    to_port          = 2049
    protocol         = "tcp"
    security_groups  = [aws_security_group.build_server.id]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Owner = "german"
    Name  = "german-efs-sg"
  }
}

resource "aws_efs_file_system" "fs" {
  encrypted = true

  tags = {
    Name  = "german-build-server"
    Owner = "german"
  }
}

resource "aws_efs_mount_target" "mount_a" {
  file_system_id  = aws_efs_file_system.fs.id
  subnet_id       = aws_subnet.private_bs_1.id
  security_groups = [aws_security_group.efs.id]
}

resource "aws_efs_mount_target" "mount_b" {
  file_system_id  = aws_efs_file_system.fs.id
  subnet_id       = aws_subnet.private_bs_2.id
  security_groups = [aws_security_group.efs.id]
}

resource "aws_iam_role" "build_server_role" {
  name = "german-build-server-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      Owner = "german"
  }
}

resource "aws_iam_instance_profile" "build_server" {
  name = "german-build-server-profile"
  role = aws_iam_role.build_server_role.name
}

resource "aws_iam_role_policy" "s3_policy" {
  name = "german-build-server-s3"
  role = aws_iam_role.build_server_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "s3:ListStorageLensConfigurations",
                "s3:ListAccessPointsForObjectLambda",
                "s3:GetAccessPoint",
                "s3:PutAccountPublicAccessBlock",
                "s3:GetAccountPublicAccessBlock",
                "s3:ListAllMyBuckets",
                "s3:ListAccessPoints",
                "s3:PutAccessPointPublicAccessBlock",
                "s3:ListJobs",
                "s3:PutStorageLensConfiguration",
                "s3:ListMultiRegionAccessPoints",
                "s3:CreateJob"
            ],
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::teamcenter"
        },
        {
            "Sid": "VisualEditor2",
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": "arn:aws:s3:::teamcenter/*"
        }
    ]
}
EOF
}

#resource "aws_lb" "dc_lb" {
#name               = "german-dc"
#internal           = false
#load_balancer_type = "application"
#security_groups    = [aws_security_group.lb_sg.id]
#subnets            = [for subnet in aws_subnet.public : subnet.id]
#
#enable_deletion_protection = true
#
#access_logs {
#bucket  = aws_s3_bucket.lb_logs.bucket
#prefix  = "test-lb"
#enabled = true
#}
#
#tags = {
#Owner = "german"
#}
#}
