output "vpc_id" {
  value = module.vpc.vpc_id
}

output "subnets" {
  value = aws_subnet.caas_public[*].id
}

output "kms_key_id" {
  value = aws_kms_key.ami.key_id
}
