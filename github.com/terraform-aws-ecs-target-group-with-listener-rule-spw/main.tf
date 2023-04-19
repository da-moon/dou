resource "aws_alb_target_group" "alb_target_group" {
  name                 = "${var.service_name}-alb-target"
  port                 = 12345 # our internal default b/c it doesn't matter.
  protocol             = "${var.target_group_protocol}"
  vpc_id               = "${var.vpc_id}"
  deregistration_delay = "${var.target_group_drain_duration}"

  health_check {
    healthy_threshold   = "${var.health_check_healthy_threshold}"
    unhealthy_threshold = "${var.health_check_unhealthy_threshold}"
    timeout             = "${var.health_check_timeout}"
    protocol            = "${var.health_check_protocol}"
    path                = "${var.health_check_path}"
    interval            = "${var.health_check_interval}"
  }
}

resource "aws_alb_listener_rule" "alb_listener_rule" {
  listener_arn = "${var.alb_listener_arn}"
  priority     = "${var.rule_priority}"

  action {
    target_group_arn = "${aws_alb_target_group.alb_target_group.arn}"
    type             = "forward"
  }

  condition {
    field  = "path-pattern"
    values = ["${split(",", var.path_patterns)}"]
  }
}
