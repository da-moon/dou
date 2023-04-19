output "project_name" {
  value = var.project_name
}

output "region" {
  value = var.aws_region
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "eip-public-ip" {
  value = data.aws_eip.licenseip.public_ip
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet[*].id
}

output "s3_bucket_url" {
  value = aws_s3_bucket.plm_hub_bucket.bucket_domain_name
}


