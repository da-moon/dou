terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.60.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.1.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "3.1.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.5.0"
    }
  }

  required_version = ">= 1.0.2"
}



# Configure the AWS Provider
provider "aws" {
  region = var.region
}

/*
 * The Kubernetes provider is included in this file so the EKS module can complete successfully. 
 * Otherwise, it throws an error when creating `kubernetes_config_map.aws_auth`.
 * You should **not** schedule deployments and services in this workspace. 
 * This keeps workspaces modular (one for provision EKS, another for scheduling Kubernetes resources) as per best practices.
 */
provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  token                  = data.aws_eks_cluster_auth.cluster.token
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
}