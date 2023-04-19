
resource "aws_security_group" "lb" {
  name        = "${var.env_name}-${var.service_name}"
  description = "Security group attached to ${var.service_name} load balancer"
  vpc_id      = var.vpc_id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    description      = "HTTPS from anywhere"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
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
    Name = "${var.env_name}-${var.service_name}"
  }
}

resource "aws_lb" "main" {
  name               = "${var.env_name}-${var.service_name}"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = var.public_subnet_ids
}

resource "aws_lb_target_group" "lb_tg" {
  name     = "${var.env_name}-${var.service_name}-tg"
  port     = var.svc_healthcheck_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    enabled           = true
    port              = var.svc_healthcheck_port
    protocol          = "HTTP"
    path              = var.svc_healthcheck_path
    healthy_threshold = 2
    interval          = 15
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }
}



##HTTPS enabled
resource "aws_lb_listener" "https" {
  count             = var.is_https ? 1 : 0
  load_balancer_arn = aws_lb.main.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_tg.arn
  }
}
