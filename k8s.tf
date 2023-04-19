
locals {
  ingress_lb_ip = data.kubernetes_service.ingress.status.0.load_balancer.0.ingress.0.ip
  domain = lookup(var.consul_tpl_values, "domain", "${local.ingress_lb_ip}.nip.io")
  proxy_pass = var.proxy_pass != "" ? var.proxy_pass : random_password.ht.result

  nginx_ingress_values_file = templatefile(
    "${path.module}/templates/nginx.yaml.tpl",
    { "values" : var.nginx_tpl_values }
  )
  consul_values_file = templatefile(
    "${path.module}/templates/consul.yaml.tpl",
    {
      "values" : merge(var.consul_tpl_values,
        {
          domain : local.domain
        }
      )
    }
  )
  vault_values_file = templatefile(
    "${path.module}/templates/vault.yaml.tpl",
    {
      "values" : merge(var.vault_tpl_values,
        {
          domain : local.domain
        }
      )
    }
  )
}

data "google_client_config" "provider" {}

provider "kubernetes" {
  host  = "https://${google_container_cluster.primary.endpoint}"
  token = data.google_client_config.provider.access_token
  cluster_ca_certificate = base64decode(
    google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
  )
}

provider "helm" {
  kubernetes {

    host  = "https://${google_container_cluster.primary.endpoint}"
    token = data.google_client_config.provider.access_token
    cluster_ca_certificate = base64decode(
      google_container_cluster.primary.master_auth[0].cluster_ca_certificate,
    )
  }
}

resource "kubernetes_namespace" "namespace" {
  depends_on = [
    google_container_node_pool.primary_preemptible_nodes
  ]
  for_each = {
    for ns in var.namespaces : ns => {}
  }
  metadata {
    name = each.key
  }
}

resource "helm_release" "ngnix-ingress" {
  depends_on = [
    google_container_node_pool.primary_preemptible_nodes
  ]
  name       = "nginx-ingress"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.0.1"
  values = [
    local.nginx_ingress_values_file,
  ]
  namespace = var.namespaces[0]
  timeout   = 1200
}

resource "helm_release" "vault" {
  depends_on = [
    google_container_node_pool.primary_preemptible_nodes,
    kubernetes_namespace.namespace,
  ]
  name       = "vault"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "vault"
  version    = "0.15.0"
  values = [
    local.vault_values_file,
  ]
  namespace = var.namespaces[0]
  timeout   = 1200
}

resource "helm_release" "consul" {
  depends_on = [
    google_container_node_pool.primary_preemptible_nodes,
    kubernetes_namespace.namespace,
  ]
  name       = "consul"
  repository = "https://helm.releases.hashicorp.com"
  chart      = "consul"
  version    = "0.33.0"
  values = [
    local.consul_values_file,
  ]
  namespace = var.namespaces[0]
  timeout   = 1200
}

data "kubernetes_service" "ingress" {
  depends_on = [
    helm_release.ngnix-ingress,
    kubernetes_namespace.namespace,
  ]
  metadata {
    name      = "nginx-ingress-ingress-nginx-controller"
    namespace = var.namespaces[0]
  }
}

resource "random_password" "ht" {
  length = 30
}

resource "htpasswd_password" "hash" {
  password = local.proxy_pass
  salt     = substr(sha512(random_password.ht.result), 0, 8)
}

resource "kubernetes_secret" "nginx" {
  depends_on = [
    kubernetes_namespace.namespace,
  ]
  metadata {
    name = "basic-auth"
    namespace = var.namespaces[0]
  }

  data = {
    auth = "${var.proxy_user}:${htpasswd_password.hash.apr1}"
  }

  type = "Opaque"
}