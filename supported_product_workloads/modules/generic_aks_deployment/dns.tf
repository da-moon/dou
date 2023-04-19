
resource "azurerm_dns_a_record" "caas" {
  name      = "service"
  zone_name = var.dns_subdomain # Uncomment if DNS zone managed by terraform
  #zone_name           = "jason-skidmore.com" # Use this if DNS zone not managed by terraform
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [kubernetes_service.azure_caas_api.status[0].load_balancer[0].ingress[0].ip]
}
