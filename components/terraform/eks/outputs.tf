output "cluster_id" {
  description = "EKS cluster ID"
  value       = module.eks.cluster_id 
}

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       =  module.eks.cluster_endpoint 
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       =  module.eks.cluster_security_group_id 
}

output "region" {
  description = "AWS region"
  value       =  var.region 
}

output "cluster_certificate" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       =  module.eks.cluster_certificate_authority_data 
}

output "oidc_issuer" {
  description = "Cluster Certificate"
  value       = module.eks.cluster_oidc_issuer_url
}

output "oidc_provider_arn" {
  description = "Cluster Certificate"
  value       = module.eks.oidc_provider_arn
}