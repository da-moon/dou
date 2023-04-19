output "load_balancer_hostname" {
  value       = kubernetes_service.nginx.status.0.load_balancer.0.ingress.0.hostname
  description = "The hostname of the load balancer"
}

output "url" {
  value       = "https://${aws_route53_record.nginx.name}"
  description = "The URL of the load balancer"
}