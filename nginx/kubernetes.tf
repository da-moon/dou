data "terraform_remote_state" "eks" {
  backend = "remote"

  config = {
    organization = "dou-armory"
    workspaces = {
      name = "armory"
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.eks.outputs.cluster_id
}

resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "nginx"
  }
}

resource "kubernetes_secret" "dockerhub" {
  metadata {
    name      = "dockerhub"
    namespace = kubernetes_namespace.nginx.id
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "${var.registry_server}" = {
          auth = "${base64encode("${var.registry_username}:${var.registry_password}")}"
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_config_map" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.nginx.id
  }

  data = {
    "default.conf" = "${file("${path.module}/config/default.conf")}"
  }
}

resource "kubernetes_config_map" "spinnaker_kube_accounts" {
  metadata {
    name      = "spinnaker-kube-accounts"
    namespace = kubernetes_namespace.nginx.id
  }

  data = {
    "kube.yml" = "${file("${path.module}/kube-accounts/kube.yml")}"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.nginx.id
    labels = {
      App = "nginx"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          App = "nginx"
        }
      }
      spec {
        image_pull_secrets {
          name = kubernetes_secret.dockerhub.metadata.0.name
        }

        container {
          image = "nginx:latest"
          name  = "nginx"

          port {
            name           = "http"
            container_port = 80
          }

          port {
            name           = "https"
            container_port = 80
          }

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }

          volume_mount {
            name       = "nginx-config"
            mount_path = "/etc/nginx/conf.d"
          }

          volume_mount {
            name       = "kube-accounts"
            mount_path = "/usr/share/nginx/accounts"
          }
        }

        volume {
          name = "nginx-config"
          config_map {
            name = kubernetes_config_map.nginx.metadata.0.name
            items {
              key  = "default.conf"
              path = "default.conf"
            }
          }
        }

        volume {
          name = "kube-accounts"
          config_map {
            name = kubernetes_config_map.spinnaker_kube_accounts.metadata.0.name
          }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      metadata.0.resource_version,
    ]
  }
}

resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx"
    namespace = kubernetes_namespace.nginx.id

    annotations = {
      # "service.beta.kubernetes.io/aws-load-balancer-internal"               = "true"
      # "service.beta.kubernetes.io/aws-load-balancer-ssl-negotiation-policy" = "ELBSecurityPolicy-TLS-1-2-2017-01"
      "service.beta.kubernetes.io/aws-load-balancer-type"             = "elb"
      "service.beta.kubernetes.io/aws-load-balancer-ssl-cert"         = "${data.aws_acm_certificate.cert.arn}"
      "service.beta.kubernetes.io/aws-load-balancer-ssl-ports"        = "https"
      "service.beta.kubernetes.io/aws-load-balancer-backend-protocol" = "http"
    }
  }
  spec {
    selector = {
      App = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.App
    }

    port {
      name        = "http"
      port        = 80
      target_port = "https"
      protocol    = "TCP"
    }

    port {
      name        = "https"
      port        = 443
      target_port = "http"
      protocol    = "TCP"
    }

    type = "LoadBalancer"
  }
}

# Create a local variable for the load balancer name.
locals {
  lb_name = split("-", split(".", kubernetes_service.nginx.status.0.load_balancer.0.ingress.0.hostname).0).0
}

data "aws_acm_certificate" "cert" {
  domain   = var.domain
  statuses = ["ISSUED"]
}

# Read information about the load balancer using the AWS provider.
data "aws_elb" "nginx" {
  name = local.lb_name
}

data "aws_route53_zone" "subdomain" {
  name = "${var.environment}.${var.domain}"
}

resource "aws_route53_record" "nginx" {
  zone_id = data.aws_route53_zone.subdomain.zone_id
  name    = "${kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.App}.${data.aws_route53_zone.subdomain.name}"
  type    = "CNAME"
  ttl     = "30"
  records = [data.aws_elb.nginx.dns_name]
}