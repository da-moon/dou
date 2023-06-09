terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.60.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.5.0"
    }
  }
}

# Retrieve EKS cluster information
provider "aws" {
  region = data.terraform_remote_state.eks.outputs.region
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}