output "target_group_arn" {
  value = aws_alb_target_group.alb_target_group.arn
}

output "dns_record_name" {
  value = aws_route53_record.dns_entry.name
}

output "dns_record_type" {
  value = aws_route53_record.dns_entry.type
}

output "alb_hosted_zone_id" {
  value = aws_alb.alb.zone_id
}

output "alb_name" {
  value = aws_alb.alb.dns_name
}

