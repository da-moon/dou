data "aws_key_pair" "key" {
  key_name           = var.ssh_key_name
  include_public_key = true
}

data "cloudinit_config" "init" {
  gzip          = "true"
  base64_encode = "true"

  part {
    content_type = "text/cloud-config"
    filename     = "cloud-config"
    content      = templatefile("${path.module}/cloud-config", {
      ssh_public_key = data.aws_key_pair.key.public_key
    })
  }
}

resource "aws_launch_configuration" "file_server" {
  name_prefix          = var.installation_prefix != "" ? "${var.installation_prefix}-tc-file-server-${var.env_name}" : "tc-file-server-${var.env_name}"
  image_id             = data.aws_ami.file_server.id
  instance_type        = var.instance_type
  key_name             = var.ssh_key_name
  iam_instance_profile = jsondecode(data.aws_s3_object.core_env_outputs.body).instance_profile_id
  security_groups      = [aws_security_group.file_server.id]
  user_data_base64     = data.cloudinit_config.init.rendered

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "file_server" {
  name                      = var.installation_prefix != "" ? "${var.installation_prefix}-tc-file-server-${var.env_name}" : "tc-file-server-${var.env_name}"
  max_size                  = var.max_instances
  min_size                  = var.min_instances
  health_check_grace_period = 300
  health_check_type         = "EC2"
  desired_capacity          = var.min_instances
  force_delete              = false
  vpc_zone_identifier       = var.instance_subnets
  launch_configuration      = aws_launch_configuration.file_server.name
  target_group_arns         = [aws_lb_target_group.file_server.arn]

  tag {
    key                 = "Name"
    value               = var.installation_prefix != "" ? "${var.installation_prefix}-tc-file-server-${var.env_name}" : "tc-file-server-${var.env_name}"
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

resource "aws_security_group" "file_server" {
  name        = var.installation_prefix != "" ? "${var.installation_prefix}-${var.env_name}-fileserver-sg" : "${var.env_name}-fileserver-sg"
  description = "Security group attached to File Server instances"
  vpc_id      = data.aws_vpc.main.id

  ingress {
    description = "SSH from same vpc"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.main.cidr_block]
  }

  ingress {
    description      = "TCP for smbd service(samba)"
    from_port        = 445
    to_port          = 445
    protocol         = "tcp"
    cidr_blocks =  ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.installation_prefix != "" ? "${var.installation_prefix}-${var.env_name}-fileserver-sg" : "${var.env_name}-filserver-sg"
  }
}

resource "aws_lb" "file_server" {
  name                       = var.installation_prefix != "" ? "tc-${var.installation_prefix}-${var.env_name}-fileserver" : "tc-${var.env_name}-fileserver"
  internal                   = false
  load_balancer_type         = "network"
  subnets                    = var.lb_subnets
  enable_deletion_protection = false
}


resource "aws_lb_target_group" "file_server" {

  name                 = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-fs-lb-tg-nlb" : "tc-${var.env_name}-fs-lb-tg"
  port                 = "445"
  protocol             = "TCP"
  vpc_id               = data.aws_vpc.main.id
  deregistration_delay = 30
  target_type          = "instance"

  health_check {
    enabled  = true
    port     = "445"
    protocol = "TCP"
  }
}


resource "aws_lb_listener" "file_server" {
  load_balancer_arn = aws_lb.file_server.arn
  port              = "445"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.file_server.arn
  }
}

