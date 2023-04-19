module "avd_fis" {
  source = "./modules/avd-fis"

  az_service_principal = var.az_service_principal
  az_client_secret = var.az_client_secret
  az_subscription_id = var.az_subscription_id
  az_tenant_id = var.az_tenant_id
  resource_group = var.resource_group
  avd_host_pool_size = var.avd_host_pool_size
  avd_users = var.avd_users
  packer_name = var.packer_name
}
