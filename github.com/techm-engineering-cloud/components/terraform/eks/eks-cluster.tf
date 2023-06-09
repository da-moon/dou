module "eks" {

  source  = "terraform-aws-modules/eks/aws"
  version = "18.26.6"

  cluster_name    = var.cluster_name
  cluster_version = "1.22"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_env_subnet_ids
  eks_managed_node_group_defaults = {
    ami_type                              = "AL2_x86_64"
    attach_cluster_primary_security_group = true
    # Disabling and using externally provided security groups
    create_security_group = false
  }

  eks_managed_node_groups = {
    one = {
      name           = "node-group-1"
      instance_types = var.instance_type

      min_size     = var.min_size
      max_size     = var.max_size
      desired_size = var.desired_size

      update_config = {
        max_unavailable = var.min_size
      }

      pre_bootstrap_user_data = <<-EOT
      echo 'foo bar'
      EOT

      vpc_security_group_ids = [
        aws_security_group.node_group_one.id
      ]
    }
  }

  manage_aws_auth_configmap = true
  aws_auth_roles = var.access_roles
  
  node_security_group_tags = {
      "kubernetes.io/cluster/${var.cluster_name}" = null
    }
}
