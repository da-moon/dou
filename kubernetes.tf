locals {
  app_name = "bitbucket"
  labels = {
    app       = local.app_name
    terraform = true
  }
}

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

resource "kubernetes_namespace" "bitbucket" {
  metadata {
    name   = local.app_name
    labels = local.labels
  }
}

resource "kubernetes_secret" "dockerhub" {
  metadata {
    name      = "dockerhub"
    namespace = kubernetes_namespace.bitbucket.id
    labels = {
      terraform = true
    }
  }

  data = {
    ".dockerconfigjson" = jsonencode({
      auths = {
        "docker.io" = {
          auth = "${base64encode("${var.dockerhub_username}:${var.dockerhub_password}")}"
        }
      }
    })
  }

  type = "kubernetes.io/dockerconfigjson"
}

resource "kubernetes_persistent_volume_claim" "bitbucket" {
  wait_until_bound = false
  metadata {
    name      = local.app_name
    namespace = kubernetes_namespace.bitbucket.id
    labels    = local.labels
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
  }

  lifecycle {
    ignore_changes = [
      metadata.0.resource_version,
    ]
  }
}

resource "kubernetes_deployment" "bitbucket" {
  metadata {
    name      = local.app_name
    namespace = kubernetes_namespace.bitbucket.id
    labels    = local.labels
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = local.app_name
      }
    }

    template {
      metadata {
        labels = local.labels
      }
      spec {
        image_pull_secrets {
          name = kubernetes_secret.dockerhub.metadata.0.name
        }

        container {
          image = "atlassian/bitbucket-server:${var.bitbucket_version}"
          name  = local.app_name

          env {
            name  = "SERVER_SCHEME"
            value = "https"
          }

          env {
            name  = "SERVER_SECURE"
            value = true
          }

          env {
            name  = "ELASTICSEARCH_ENABLED"
            value = false
          }

          env {
            name  = "AUTH_REMEMBER_ME_TOKEN_EXPIRY"
            value = 30
          }

          port {
            name           = "http"
            container_port = 7990
          }

          resources {
            limits = {
              cpu    = "2"
              memory = "3072Mi"
            }
            requests = {
              cpu    = "1"
              memory = "1024Mi"
            }
          }

          volume_mount {
            name       = "${local.app_name}-data"
            mount_path = "/var/atlassian/application-data/bitbucket"
          }
        }

        volume {
          name = "${local.app_name}-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.bitbucket.metadata.0.name
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

resource "kubernetes_ingress" "bitbucket" {
  metadata {
    name      = local.app_name
    namespace = kubernetes_namespace.bitbucket.id
    labels    = local.labels

    annotations = {
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "kubernetes.io/ingress.class"               = "alb"
#       "alb.ingress.kubernetes.io/certificate-arn" = data.aws_acm_certificate.cert.arn
      "alb.ingress.kubernetes.io/listen-ports" = jsonencode([
        {
          "HTTP"  = 80,
          "HTTPS" = 443
        }
      ])
      "alb.ingress.kubernetes.io/actions.ssl-redirect" = jsonencode({
        "Type" = "redirect",
        "RedirectConfig" = {
          "Protocol"   = "HTTPS",
          "Port"       = "443",
          "StatusCode" = "HTTP_301"
        }
      })
    }
  }

  spec {
    rule {
      host = "${local.app_name}.${data.aws_route53_zone.subdomain.name}"

      http {
        path {
          backend {
            service_name = "ssl-redirect"
            service_port = "use-annotation"
          }

          path = "/*"
        }

        path {
          backend {
            service_name = kubernetes_service.bitbucket.metadata.0.name
            service_port = kubernetes_service.bitbucket.spec.0.port.0.port
          }

          path = "/*"
        }
      }
    }
  }

  wait_for_load_balancer = true
}

resource "kubernetes_service" "bitbucket" {
  metadata {
    name      = local.app_name
    namespace = kubernetes_namespace.bitbucket.id

#     annotations = {
#       "alb.ingress.kubernetes.io/certificate-arn" = data.aws_acm_certificate.cert.arn
#     }

    labels = local.labels
  }

  spec {
    selector = {
      app = kubernetes_deployment.bitbucket.spec.0.template.0.metadata[0].labels.app
    }

    port {
      name        = "http"
      port        = 80
      target_port = "http"
      protocol    = "TCP"
    }

    port {
      name        = "https"
      port        = 443
      target_port = "http"
      protocol    = "TCP"
    }

    type = "NodePort"
  }
}

# data "aws_acm_certificate" "cert" {
#   domain   = var.domain
#   statuses = ["ISSUED"]
# }

data "aws_route53_zone" "subdomain" {
  name = "${var.environment}.${var.domain}"
}

resource "aws_route53_record" "bitbucket" {
  zone_id = data.aws_route53_zone.subdomain.zone_id
  name    = "${local.app_name}.${data.aws_route53_zone.subdomain.name}"
  type    = "CNAME"
  ttl     = "30"
  records = [kubernetes_ingress.bitbucket.status.0.load_balancer.0.ingress.0.hostname]
}
