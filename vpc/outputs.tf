output "vpc_name" {
  value = module.vpc.name
}

output "cidr" {
  value = module.vpc.default_vpc_cidr_block
}

output "vpc_id" {
  value = module.vpc.default_vpc_id
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