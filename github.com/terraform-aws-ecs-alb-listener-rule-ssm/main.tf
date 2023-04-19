resource "aws_alb_listener_rule" "alb_listener_rule" {
  listener_arn = var.alb_listener_arn
  priority     = var.rule_priority

  action {
    target_group_arn = var.target_group_arn
    type             = "forward"
  }

  condition {
    field  = "path-pattern"
    values = split(",", var.path_patterns)
  }
}

