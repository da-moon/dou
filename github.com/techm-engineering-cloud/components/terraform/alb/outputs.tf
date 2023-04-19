
output "lb_sg_id" {
  value = aws_security_group.lb.id
}

output "lb_tg_arn" {
  value = aws_lb_target_group.lb_tg.arn
}

output "lb_arn" {
  value = aws_lb.main.arn
}

output "lb_dns" {
  value = aws_lb.main.dns_name
}

