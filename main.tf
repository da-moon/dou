module "vpc" {
  source                 = "./modules/vpc"
  app_name               = var.app_name
  stage_name             = var.stage_name
  aws_availability_zones = data.aws_availability_zones.available.names
  create_vpc             = var.create_vpc
  cidr                   = var.vpc_cidr
  public_subnets         = var.public_subnets
  private_subnets        = var.private_subnets
  cluster_name           = var.cluster_name
  multi_az_deployment    = var.multi_az_deployment
}

data "aws_availability_zones" "available" {
}

# elastic file service
# Create the Amazon EFS Network file system before you can use the CSI driver to mount it inside a container as a persistent volume. 
# Currently, the CSI driver doesn’t provision the Amazon EFS file system automatically.
module "efs" {
  source             = "./modules/efs"
  app_name           = var.app_name
  stage_name         = var.stage_name
  vpcid              = module.vpc.vpc_id
  private_subnets    = var.private_subnets
  private_subnet_ids = module.vpc.private_subnet_ids
  create_efs         = var.app_create_efs
}

module "security-groups" {
  source                         = "./modules/security-groups"
  app_name                       = var.app_name
  stage_name                     = var.stage_name
  create_vpc                     = module.vpc.create_vpc
  vpcid                          = module.vpc.vpc_id
  public_subnets                 = var.public_subnets
  private_subnets                = var.private_subnets
  private_networking             = var.private_networking
  ingress_gateway_container_port = var.app_ingress_gateway_container_port
  multi_az_deployment            = var.multi_az_deployment
  envoy_proxy_egress_cidr_block  = var.envoy_proxy_egress_cidr_block
}

module "iam" {
  source = "./modules/iam"
}

module "cluster" {
  source                    = "./modules/cluster"
  app_name                  = var.app_name
  stage_name                = var.stage_name
  cluster_name              = var.cluster_name
  cluster_public_access     = var.cluster_public_access
  role_arn                  = module.iam.eks_cluster_iam_role_arn
  cluster_version           = var.k8s_version
  public_subnet_ids         = module.vpc.public_subnet_ids
  private_subnet_ids        = module.vpc.private_subnet_ids
  enabled_cluster_log_types = var.enabled_cluster_log_types
  private_networking        = var.private_networking
}

module "app_fargate_profile" {
  source                 = "./modules/fargate"
  app_name               = var.app_name
  stage_name             = var.stage_name
  profile_name           = "fp-app"
  cluster_name           = module.cluster.eks_cluster_name
  subnet_ids             = module.vpc.private_subnet_ids
  pod_execution_role_arn = module.iam.eks_fargate_pod_execution_iam_role_arn
  selectors = [{ namespace = "default" }, { namespace = "calculator" },
    { namespace = "bookinfo" }, { namespace = "todos" },
  { namespace = "todos-api" }]
}

module "core_fargate_profile" {
  source                 = "./modules/fargate"
  app_name               = var.app_name
  stage_name             = var.stage_name
  profile_name           = "fp-core"
  cluster_name           = module.cluster.eks_cluster_name
  subnet_ids             = module.vpc.private_subnet_ids
  pod_execution_role_arn = module.iam.eks_fargate_pod_execution_iam_role_arn
  selectors = [
    { namespace = "kube-system" },
    { namespace = "kubernetes-dashboard" },
    { namespace = "appmesh-system" },
    { namespace = "external-secrets" },
    { namespace = "cert-manager" }
  ]
}

module "observability_fargate_profile" {
  source                 = "./modules/fargate"
  app_name               = var.app_name
  stage_name             = var.stage_name
  profile_name           = "fp-observability"
  cluster_name           = module.cluster.eks_cluster_name
  subnet_ids             = module.vpc.private_subnet_ids
  pod_execution_role_arn = module.iam.eks_fargate_pod_execution_iam_role_arn
  selectors = [
    { namespace = "prometheus" },
    { namespace = "amazon-cloudwatch" }
  ]
}