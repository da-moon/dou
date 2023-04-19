output "vpc_name" {
  value = module.vpc.name
}

output "cidr" {
  value = module.vpc.vpc_cidr_block
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "priv_subnets" {
  value = module.vpc.private_subnets
}

output "priv_subnets_cidr" {
  value = module.vpc.private_subnets_cidr_blocks
}

output "pub_subnets" {
  value = module.vpc.public_subnets
}

output "pub_subnets_cidr" {
  value = module.vpc.public_subnets_cidr_blocks
}

output "s3_bucket_id" {
  value = module.s3_bucket.s3_bucket_id
}

output "file_system_id" {
  value = module.openzfs.fsx_openzfs_id
}

output "file_system_dns_name" {
  value = module.openzfs.fsx_openzfs_dns_name
}
output "security_group_id" {
  value = module.security-group.security_group_id
}

output "id-master" {
  value = module.iam.id-master
}

output "arn-master" {
  value = module.iam.arn-master
}

output "name-master" {
  value = module.iam.name-master
}

output "role-master" {
  value = module.iam.role-master
}

output "id-server" {
  value = module.iam.id-server
}

output "arn-server" {
  value = module.iam.arn-server
}

output "name-server" {
  value = module.iam.name-server
}

output "role-server" {
  value = module.iam.role-server
}