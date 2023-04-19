data "aws_ami" "ubuntu_jammy_base_ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20220420"]
  }
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "template_file" "user_data" {
  template = "${file("./${path.module}/user_data.sh")}"

  vars = {
    eip_allocid = var.eip_allocid
  }
}

resource "aws_launch_configuration" "bastion" {
  name_prefix                 = "${var.env_name}-bastion-"
  image_id                    = data.aws_ami.ubuntu_jammy_base_ami.id
  instance_type               = "t3.small"
  key_name                    = var.ssh_key_name
  user_data                   = base64encode(data.template_file.user_data.rendered)
  associate_public_ip_address = true
  security_groups             = [aws_security_group.bastion.id]
  iam_instance_profile        = aws_iam_instance_profile.bastion.name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion" {
  name                      = "${var.env_name}-bastion"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = false
  vpc_zone_identifier       = var.subnet_ids
  launch_configuration      = aws_launch_configuration.bastion.name

  tag {
    key                 = "Name"
    value               = "${var.env_name}-bastion"
    propagate_at_launch = true
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "bastion" {
  name        = "${var.env_name}-bastion"
  description = "Security group for bastion host"
  vpc_id      = var.vpc_id

  ingress {
    description      = "SSH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
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
    Name        = "${var.env_name}-bastion"
    Environment = var.env_name
  }
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${var.env_name}-bastion-profile"
  role = aws_iam_role.bastion.name
}

resource "aws_iam_role" "bastion" {
  name = "${var.env_name}-bastion-role"

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
}

resource "aws_iam_role_policy" "bastion" {
  name = "${var.env_name}-bastion-policy"
  role = aws_iam_role.bastion.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeAddresses",
                "ec2:AssociateAddress"
            ],
            "Resource": "*"
        }
    ]
}
EOF
}

