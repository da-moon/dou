
data "aws_vpc" "main" {
  id = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id
}

resource "aws_security_group" "swarm" {
  name   = "${local.prefix}tf-swarm"
  vpc_id = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "Traffic to service dispatcher from vpc"
    from_port        = nonsensitive(data.aws_ssm_parameter.ms_port.value)
    to_port          = nonsensitive(data.aws_ssm_parameter.ms_port.value)
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_security_group" "ms_lb_sg" {
  count = data.aws_ssm_parameter.container_orchestration.value == "Docker Swarm" ? 1 : 0
  name        = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-ms-lb-sg" : "tc-${var.env_name}-ms-lb-sg"
  description = "Security group attached to microservices load balancer"
  vpc_id      = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id

  ingress {
    description      = "Traffic to service dispatcher from vpc"
    from_port        = nonsensitive(data.aws_ssm_parameter.ms_port.value)
    to_port          = nonsensitive(data.aws_ssm_parameter.ms_port.value)
    protocol         = "tcp"
    cidr_blocks      = [data.aws_vpc.main.cidr_block]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-ms-lb-sg" : "tc-${var.env_name}-ms-lb-sg"
  }
}

resource "aws_lb" "ms_lb" {
  count = data.aws_ssm_parameter.container_orchestration.value == "Docker Swarm" ? 1 : 0
  name                       = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-ms" : "tc-${var.env_name}-ms"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.ms_lb_sg[0].id]
  subnets                    = jsondecode(data.aws_s3_object.core_env_outputs.body).private_env_subnet_ids
  enable_deletion_protection = false
  idle_timeout               = 3600
}

resource "aws_lb_target_group" "ms_tg" {
  count = data.aws_ssm_parameter.container_orchestration.value == "Docker Swarm" ? 1 : 0
  name                 = var.installation_prefix != "" ? "${var.installation_prefix}-tc-${var.env_name}-ms-tg" : "tc-${var.env_name}-ms-tg"
  port                 = nonsensitive(data.aws_ssm_parameter.ms_port.value)
  protocol             = "HTTP"
  vpc_id               = jsondecode(data.aws_s3_object.core_outputs.body).vpc_id
  deregistration_delay = 30

  health_check {
    enabled           = true
    port              = nonsensitive(data.aws_ssm_parameter.ms_port.value)
    protocol          = "HTTP"
    path              = "/"
    healthy_threshold = 2
    interval          = 15
    matcher           = "200-299,300-399,400-499"
  }
}

resource "aws_lb_listener" "ms_listener" {
  count = data.aws_ssm_parameter.container_orchestration.value == "Docker Swarm" ? 1 : 0
  load_balancer_arn = aws_lb.ms_lb[0].arn
  port              = nonsensitive(data.aws_ssm_parameter.ms_port.value)
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ms_tg[0].arn
  }
  depends_on = [aws_lb_target_group.ms_tg]
}

resource "aws_route53_record" "ms_record" {
  count = data.aws_ssm_parameter.container_orchestration.value == "Docker Swarm" ? 1 : 0
  zone_id = jsondecode(data.aws_s3_object.core_outputs.body).private_hosted_zone_id
  name    = nonsensitive(data.aws_ssm_parameter.master_hostname.value)
  type    = "CNAME"
  ttl     = "300"
  records = [aws_lb.ms_lb[0].dns_name]
}

