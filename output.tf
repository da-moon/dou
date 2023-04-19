output "access_sg_id" {
  value = aws_security_group.db_access.id
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

output "instance_type" {
  value = aws_db_instance.base_rds.instance_class
}

output "identifier" {
  value = aws_db_instance.base_rds.identifier
}

output "allocated_storage" {
  value = aws_db_instance.base_rds.allocated_storage
}

output "engine" {
  value = aws_db_instance.base_rds.engine
}

output "engine_version" {
  value = aws_db_instance.base_rds.engine_version
}

output "instance_class" {
  value = aws_db_instance.base_rds.instance_class
}

output "password" {
  value = aws_db_instance.base_rds.password
}

output "username" {
  value = aws_db_instance.base_rds.username
}

output "source_instance_arn" {
  value = aws_db_instance.base_rds.arn
}

output "port" {
  value = aws_db_instance.base_rds.port
}

# output "monitoring_role_arn" {
#   value = aws_iam_role.rds_enhanced_monitoring.identifier
# }
