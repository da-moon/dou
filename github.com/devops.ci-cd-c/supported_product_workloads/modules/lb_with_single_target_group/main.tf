# ALB
resource "aws_lb" "lb" {
  name_prefix     = var.run_env
  internal        = false
  security_groups = [var.security_groups]
  subnets         = var.subnets
  idle_timeout    = var.lb_idle_timeout

  tags = {
    env = var.run_env
    ## Adding servicename for Datadog filters to match other filters using "servicename" for other legacy apis.
    servicename = var.service_name
    servicetype = var.project_name
  }
}

resource "aws_lb_target_group" "lb_target_group" {
  #name                 = "${var.run_env}-${var.service_name}-${var.optional_subdomain}"
  port                 = var.lb_target_group_port
  protocol             = var.target_group_protocol
  target_type          = "ip"
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

  depends_on = [aws_lb.lb]
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb.arn
  port              = var.lb_listener_port

  default_action {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    type             = "forward"
  }

  depends_on = [aws_lb_target_group.lb_target_group]
}

resource "aws_lb_listener_rule" "lb_listener_rule" {
  listener_arn = aws_lb_listener.lb_listener.arn
  priority     = 1

  action {
    target_group_arn = aws_lb_target_group.lb_target_group.arn
    type             = "forward"
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  depends_on = [aws_lb_listener.lb_listener]
}

##########################
#        DNS             #
##########################

resource "aws_route53_record" "dns_entry" {
  zone_id = var.hosted_zone_id
  name    = "${var.service_name}.${var.project_name}.${data.aws_route53_zone.hosted_zone.name}"
  type    = "A"

  alias {
    name                   = aws_lb.lb.dns_name
    zone_id                = aws_lb.lb.zone_id
    evaluate_target_health = false
  }

  depends_on = [aws_lb_listener_rule.lb_listener_rule]
}

data "aws_route53_zone" "hosted_zone" {
  zone_id      = var.hosted_zone_id
  private_zone = true
}
