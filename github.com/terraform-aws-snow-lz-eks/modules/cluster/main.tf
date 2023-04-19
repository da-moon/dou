locals {
  name_suffix = "${var.app_name}-${var.stage_name}"
  subnet_ids  = concat((var.private_networking ? [] : var.public_subnet_ids), var.private_subnet_ids)
}

#tfsec:ignore:aws-eks-encrypt-secrets
resource "aws_eks_cluster" "main" {
  name = var.cluster_name
  # control plane logging to enable
  enabled_cluster_log_types = var.enabled_cluster_log_types

  vpc_config {

    endpoint_public_access = var.cluster_public_access
    subnet_ids             = local.subnet_ids
  }

  role_arn = var.role_arn
  version  = var.cluster_version

  tags = {
    Name = "eks-cluster-${local.name_suffix}"
  }
}

data "tls_certificate" "main" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer

  depends_on = [
    aws_eks_cluster.main
  ]
}

resource "aws_iam_openid_connect_provider" "cluster_oidc_provider" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.main.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer

  depends_on = [
    data.tls_certificate.main
  ]
}
