## VPC ##
output "vpc_id" {
  description = "VCP ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public Subnets ID"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private Subnets ID"
  value       = module.vpc.private_subnet_ids
}

## EFS
output "efs_id" {
  description = "EFS ID"
  value       = module.efs.id
}

output "efs_dns_name" {
  description = "EFS DNS name"
  value       = module.efs.dns_name
}

# IAM
output "eks_cluster_iam_role_name" {
  description = "EKS cluster IAM role"
  value       = module.iam.eks_cluster_iam_role_name
}

output "eks_fargate_pod_execution_iam_role_name" {
  description = "EKS fargate Pod execution iam role"
  value       = module.iam.eks_fargate_pod_execution_iam_role_name
}

# EKS Cluster
output "eks_cluster_id" {
  description = "EKS cluster ID"
  value       = module.cluster.eks_cluster_id
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.cluster.eks_cluster_name
}

output "eks_cluster_status" {
  description = " EKS cluster status"
  value       = module.cluster.eks_cluster_status
}

# Fargate
output "app_fargate_profile_id" {
  description = "Fargate Profile ID"
  value       = module.app_fargate_profile.id
}

output "app_fargate_profile_status" {
  description = "Fargate Profile Status"
  value       = module.app_fargate_profile.status
}

# Fargate observability
output "observability_fargate_profile_id" {
  description = "Observability Fargate profile ID"
  value       = module.observability_fargate_profile.id
}

output "observability_fargate_profile_status" {
  description = "Observability Fargate profile Status"
  value       = module.observability_fargate_profile.status
}