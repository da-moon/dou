output "cluster_id" {
  description = "EKS cluster ID."
  value       = module.eks.cluster_id
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane."
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane."
  value       = module.eks.cluster_security_group_id
}

# output "kubectl_config" {
#   description = "kubectl config as generated by the module."
#   value       = module.eks.kubeconfig
# }

# output "config_map_aws_auth" {
#   description = "A kubernetes configuration to authenticate to this EKS cluster."
#   value       = module.eks.config_map_aws_auth
# }

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = local.cluster_name
}

output "elasticache_endpoint" {
  description = "Elasticache Primary Endpoint"
  value       = aws_elasticache_replication_group.spinnaker.primary_endpoint_address
}

# RDS
output "db_instance_endpoint" {
  description = "The connection endpoint"
  value       = module.db.db_instance_endpoint
}

output "db_instance_id" {
  description = "The RDS instance ID"
  value       = module.db.db_instance_id
}

# DNS
output "acm_certificate_arn" {
  description = "The ARN of the certificate"
  value       = module.acm.acm_certificate_arn
}

output "distinct_domain_names" {
  description = "List of distinct domains names used for the validation."
  value       = module.acm.distinct_domain_names
}