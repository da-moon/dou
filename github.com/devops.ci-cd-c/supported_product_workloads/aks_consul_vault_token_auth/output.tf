// output "eks_lb_ip" {
//   value = kubernetes_service.django1.load_balancer_ingress[0].hostname
// }

output "aks_lb_ip" {
  value = module.aks_deployment.aks_lb_ip
}
