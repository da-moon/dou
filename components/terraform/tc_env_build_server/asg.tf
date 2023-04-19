
data "aws_key_pair" "key" {
  key_name           = var.ssh_key_name
  include_public_key = true
}

data "cloudinit_config" "init" {
  gzip          = "false"
  base64_encode = "false"

  part {
    content_type = "text/cloud-config"
    filename     = "cloud-config"
    content      = templatefile("${path.module}/cloud-config", {
      ssh_public_key = data.aws_key_pair.key.public_key
    })
  }

  part {
    content_type = "text/x-shellscript"
    filename     = "user_data.sh"
    content      = templatefile("${path.module}/user_data.sh", {
      machine_name            = local.machine_name
      private_hosted_zone_arn = data.aws_route53_zone.private.arn
      private_hosted_zone_dns = data.aws_route53_zone.private.name
    })
  }
}

resource "aws_launch_configuration" "build_server" {
  name_prefix          = "${local.prefix}-build-server-"
  image_id             = data.aws_ami.build_server.id
  instance_type        = var.instance_type
  key_name             = var.ssh_key_name
  iam_instance_profile = aws_iam_instance_profile.build_server.name
  security_groups      = [aws_security_group.build_server.id]
  user_data            = base64encode(data.cloudinit_config.init.rendered)

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "build_server" {
  name                      = "${local.prefix}-build-server"
  max_size                  = 1
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = 1
  force_delete              = false
  vpc_zone_identifier       = var.subnet_ids
  launch_configuration      = aws_launch_configuration.build_server.name

  tag {
    key                 = "Name"
    value               = "${local.prefix}-build-server"
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

resource "aws_security_group" "build_server" {
  name        = "${local.prefix}-build-server"
  description = "Security group attached to build server instance for environment ${var.env_name}"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "SSH from same vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${local.prefix}-build-server"
  }
}

