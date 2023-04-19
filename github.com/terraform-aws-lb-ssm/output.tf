output "dns_record_name" {
  value = aws_route53_record.dns_entry.name
}

output "dns_record_type" {
  value = aws_route53_record.dns_entry.type
}

output "dns_record_alias_name" {
  value = aws_route53_record.dns_entry.alias.name
}

output "dns_record_alias_zone_id" {
  value = aws_route53_record.dns_entry.alias.zone_id
}

output "alb_hosted_zone_id" {
  value = aws_alb.alb.zone_id
}

output "alb_name" {
  value = aws_alb.alb.dns_name
}

output "arn" {
  value = aws_alb.alb.arn
}

