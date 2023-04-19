data "aws_eks_cluster" "eks" {
  name = "eks-tc"
}

data "aws_eks_cluster_auth" "eks" {
  name = "eks-tc"
}

data "tls_certificate" "cert" {
  url = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
}


//already created
#resource "aws_iam_openid_connect_provider" "openid_connect" {
#  client_id_list  = ["sts.amazonaws.com"]
#  thumbprint_list = [data.tls_certificate.cert.certificates.0.sha1_fingerprint]
#  url             = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
#}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks.token
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority.0.data)
    token                  = data.aws_eks_cluster_auth.eks.token
    #load_config_file       = false
  }
}

