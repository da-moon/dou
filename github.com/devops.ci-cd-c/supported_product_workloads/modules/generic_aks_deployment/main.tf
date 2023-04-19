###
###
resource "kubernetes_deployment" "azure_caas_api" {
  metadata {
    name = var.service_name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = var.service_name
      }
    }

    template {
      metadata {
        labels = {
          app = var.service_name
        }
      }

      spec {
        container {
          name  = var.service_name
          image = "acr${var.service_name}.azurecr.io/${var.container_image}:${var.container_version}"

          port {
            container_port = var.container_port
          }

          env {
            name  = "VAULT_TOKEN"
            value = var.vault_token
          }

          env {
            name  = "CONSUL_TOKEN"
            value = var.consul_token
          }

          env {
            name  = "KEYS_DIR"
            value = var.keys_dir
          }

          env {
            name  = "VAULT_DEV_LISTEN_ADDRESS"
            value = var.vault_host
          }

          env {
            name  = "CONSUL_DEV_LISTEN_ADDRESS"
            value = var.consul_host
          }

          resources {
            limits = {
              cpu    = "2000m"
              memory = "2056Mi"
            }
            requests = {
              cpu    = "1500m"
              memory = "1024Mi"
            }
          }
        }

        node_selector = {
          "beta.kubernetes.io/os" = "linux"
        }
      }
    }

    strategy {
      rolling_update {
        max_unavailable = "1"
        max_surge       = "1"
      }
    }

    min_ready_seconds = 5
  }
}

resource "kubernetes_service" "azure_caas_api" {
  metadata {
    name = var.service_name
  }

  spec {
    port {
      port = var.container_port
    }

    selector = {
      app = var.service_name
    }

    type = "LoadBalancer"
  }
}
