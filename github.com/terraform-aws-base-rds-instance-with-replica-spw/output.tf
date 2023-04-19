output "access_sg_id" {
  value = module.rds_base.access_sg_id
}

output "dns_record_name" {
  value = module.rds_base.dns_record_name
}

output "dns_record_name_replica" {
  value = aws_route53_record.cname_record_replica.name
}

output "dns_record_value" {
  value = module.rds_base.dns_record_value
}

output "dns_record_value_replica" {
  value = aws_route53_record.cname_record_replica.records
}

output "dns_record_type" {
  value = module.rds_base.dns_record_type
}

output "hostname" {
  value =  module.rds_base.hostname
}

output "replica_hostname" {
  value =  aws_route53_record.cname_record_replica.fqdn
}

output "instance_type" {
  value = module.rds_base.instance_type
}

output "identifier" {
  value = module.rds_base.identifier
}

output "allocated_storage" {
  value = module.rds_base.allocated_storage
}

output "engine" {
  value = module.rds_base.engine
}

output "engine_version" {
  value = module.rds_base.engine_version
}

output "instance_class" {
  value = module.rds_base.instance_class
}

output "password" {
  value = module.rds_base.password
}

output "username" {
  value = module.rds_base.username
}

output "source_instance_arn" {
  value = module.rds_base.source_instance_arn
}

output "port" {
  value = module.rds_base.port
}

output "replica_port" {
  value = aws_db_instance.base_rds_replica.port
}
