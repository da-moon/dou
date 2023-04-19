
resource "aws_security_group" "lb" {
  name        = "${local.prefix}-deployment-center-lb"
  description = "Security group attached to Deployment Center load balancer"
  vpc_id      = data.aws_vpc.main.id

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
    Name = "${local.prefix}-deployment-center"
  }
}

resource "aws_lb" "deployment_center" {
  name               = "${local.prefix}-deployment-center"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = var.lb_subnets
}

resource "aws_lb_target_group" "deployment_center" {
  name     = "${local.prefix}-deployment-center"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id

  health_check {
    enabled           = true
    port              = 8080
    protocol          = "HTTP"
    path              = "/deploymentcenter/"
    healthy_threshold = 2
    interval          = 15
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.deployment_center.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.deployment_center.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.deployment_center.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.deployment_center.arn
  }
}

resource "aws_ssm_parameter" "dc_url" {
  name           = "/teamcenter/shared/deployment_center/url"
  type           = "String"
  insecure_value = aws_lb.deployment_center.dns_name
  overwrite      = true
}

