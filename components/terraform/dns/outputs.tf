output "private_hosted_zone_arn" {
    value = aws_route53_zone.private.arn 
}
output "private_hosted_zone_id" {
    value = aws_route53_zone.private.id 
}
