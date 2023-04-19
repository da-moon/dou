# ALB

resource "aws_alb" "alb" {
  name_prefix     = var.run_env
  internal        = true
  security_groups = [var.security_groups]
  subnets         = split(",", var.subnets)
  idle_timeout    = var.alb_idle_timeout

  tags = {
    env          = var.run_env
    service_name = var.service_name
    servicetype  = var.optional_subdomain
  }
}

resource "aws_alb_target_group" "alb_target_group" {
  #name                 = "${var.service_name}-alb-target"
  port                 = var.alb_target_group_port
  protocol             = var.target_group_protocol
  vpc_id               = var.vpc_id
  deregistration_delay = var.target_group_drain_duration

  health_check {
    healthy_threshold   = var.health_check_healthy_threshold
    unhealthy_threshold = var.health_check_unhealthy_threshold
    timeout             = var.health_check_timeout
    protocol            = var.health_check_protocol
    path                = var.health_check_path
    interval            = var.health_check_interval
    matcher             = var.health_check_matcher
  }

  depends_on = [aws_alb.alb]
}

resource "aws_alb_listener" "alb_listener" {
  count             = var.is_http_required == "yes" ? 1 : 0
  load_balancer_arn = aws_alb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.alb_target_group.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "alb_listener_resource" {
  count        = var.is_http_required == "yes" ? 1 : 0
  listener_arn = aws_alb_listener.alb_listener[0].arn
  priority     = 1

  action {
    target_group_arn = aws_alb_target_group.alb_target_group.arn
    type             = "forward"
  }

  condition {
    field  = "path-pattern"
    values = ["*"]
  }
}

resource "aws_alb_listener" "alb_ssl_listener" {
  load_balancer_arn = aws_alb.alb.arn
  port              = "443"
  protocol          = "HTTPS"

  ssl_policy      = "ELBSecurityPolicy-2015-05"
  certificate_arn = var.certificate_arn

  default_action {
    target_group_arn = aws_alb_target_group.alb_target_group.arn
    type             = "forward"
  }
}

resource "aws_alb_listener_rule" "alb_ssl_listener_resource" {
  listener_arn = aws_alb_listener.alb_ssl_listener.arn
  priority     = 1

  action {
    target_group_arn = aws_alb_target_group.alb_target_group.arn
    type             = "forward"
  }

  condition {
    field  = "path-pattern"
    values = ["*"]
  }
}

##########################
#        DNS             #
##########################

resource "aws_route53_record" "dns_entry" {
  zone_id = var.hosted_zone_id
  name    = "${var.service_name}.${var.optional_subdomain}.${data.aws_route53_zone.hosted_zone.name}"
  type    = "A"

  alias {
    name                   = aws_alb.alb.dns_name
    zone_id                = aws_alb.alb.zone_id
    evaluate_target_health = false
  }

  depends_on = [aws_alb_listener_rule.alb_ssl_listener_resource]
}

data "aws_route53_zone" "hosted_zone" {
  zone_id      = var.hosted_zone_id
  private_zone = true
}
