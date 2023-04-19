output "target_group_arn" {
  value = aws_alb_target_group.alb_target_group.arn
}

output "listener_arn" {
  value = aws_alb_listener.alb_listener.arn
}

