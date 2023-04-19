
output "aks_lb_ip" {
  value = kubernetes_service.azure_caas_api.status[0].load_balancer[0].ingress[0].ip

}
