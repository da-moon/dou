# vim: filetype=terraform syntax=terraform softtabstop=2 tabstop=2 shiftwidth=2 fileencoding=utf-8 expandtab
# code: language=terraform insertSpaces=true tabSize=2

module "ecr" {
  source     = "./modules/ecr"
  depends_on = [data.aws_ecr_authorization_token.this]
  providers = {
    aws                = aws
    docker.docker-src  = docker.docker-src
    docker.docker-dest = docker.docker-dest
  }
  project_name      = var.project_name
  docker_image_name = var.src_docker_image_name
  docker_image_tags           = var.src_docker_image_tags
  lifecyle_policy_image_count = var.ecr_lifecyle_policy_image_count
}
module "vpc" {
  source = "./modules/vpc"
  providers = {
    aws = aws
  }
  availablity_zone_count = var.availablity_zone_count
  project_name           = var.project_name
  cidr_block             = var.cidr_block
}
module "alb" {
  source = "./modules/alb"
  depends_on = [
    module.vpc,
  ]
  providers = {
    aws = aws
  }
  project_name      = var.project_name
  ingress_cidr      = var.alb_ingress_cidr
  health_check_path = var.health_check_path
  vpc_id            = module.vpc.id
  public_subnet_ids = values(module.vpc.public_subnet_id)
}
module "ecs" {
  source = "./modules/ecs"
  depends_on = [
    module.vpc,
    module.alb,
    module.ecr,
  ]
  providers = {
    aws = aws
  }
  project_name        = var.project_name
  memory_limit        = var.fargate_memory_limit
  cpu_limit           = var.fargate_cpu_limit
  app_port            = var.app_port
  app_count           = var.app_count
  vpc_id              = module.vpc.id
  alb_sg_id           = module.alb.security_group_id
  alb_target_group_id = module.alb.target_group_id
  private_subnet_ids  = values(module.vpc.private_subnet_id)
  docker_image        = var.src_docker_image_name
  docker_image_tag    = var.deployment_image_tag
}
