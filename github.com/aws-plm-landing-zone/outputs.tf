
# output "ecs_aws_elb_public_dns" {
#   value = aws_lb.main.dns_name
# }

output "s3_bucket_url" {
  value = aws_s3_bucket.caas_bucket.bucket_domain_name
}

output "caas_security_groups" {
  value = aws_security_group.caas_dev.id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_id" {
  value = [for s in aws_subnet.caas_public : s.id]
}

output "hosted_zone_id" {
  value = data.aws_route53_zone.douterraform.zone_id
}

output "rds_fqdn" {
  value = aws_route53_record.cname_record.fqdn
}

output "dns_record_name" {
  value = aws_route53_record.cname_record.name
}

output "dns_record_value" {
  value = aws_route53_record.cname_record.records
}

output "dns_record_type" {
  value = aws_route53_record.cname_record.type
}

output "hostname" {
  value =  aws_route53_record.cname_record.fqdn
}

output "project_name" {
  value = var.project_name
}

output "ec2-instance-public-ip" {
  value = aws_instance.bastian.public_ip
}

