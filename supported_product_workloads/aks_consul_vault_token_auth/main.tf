module "aks_deployment" {
  source              = "../modules/generic_aks_deployment"
  cluster_name        = local.cluster_name
  resource_group_name = local.resource_group_name
  service_name        = local.service_name
  container_image     = var.container_image
  container_version   = var.container_version
  container_port      = local.container_port
  vault_host          = data.terraform_remote_state.landing_zone.outputs.vault_dns
  consul_host         = data.terraform_remote_state.landing_zone.outputs.consul_dns
  landing_zone        = var.landing_zone
  dns_subdomain       = data.terraform_remote_state.landing_zone.outputs.subdomain_zone_name
  vault_token         = local.vault_token
  consul_token        = local.consul_token
  keys_dir            = local.keys_dir

}
