output "target_group_arn" {
  value = aws_lb_target_group.lb_target_group.arn
}

output "dns_record_name" {
  value = aws_route53_record.dns_entry.name
}

output "dns_record_type" {
  value = aws_route53_record.dns_entry.type
}

output "lb_hosted_zone_id" {
  value = aws_lb.lb.zone_id
}

output "lb_name" {
  value = aws_lb.lb.dns_name
}
