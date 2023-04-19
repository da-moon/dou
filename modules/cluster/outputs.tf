output "eks_cluster_id" {
  description = " Name of the cluster."
  value       = aws_eks_cluster.main.id
}

output "eks_cluster_name" {
  description = "Name of the cluster."
  value       = aws_eks_cluster.main.name
}

output "eks_cluster_status" {
  description = "Status of the EKS cluster. One of CREATING, ACTIVE, DELETING, FAILED."
  value       = aws_eks_cluster.main.status
}