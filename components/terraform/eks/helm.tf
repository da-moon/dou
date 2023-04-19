# Install efs-csi-driver
resource "helm_release" "kubernetes_efs_csi_driver" {
  depends_on = [var.mod_dependency, module.eks]
  name       = var.helm_chart_name
  chart      = var.helm_chart_release_name
  repository = var.helm_chart_repo
  version    = var.helm_chart_version
  namespace  = var.namespace

  set {
    name  = "controller.serviceAccount.create"
    value = "true"
  }

  set {
    name  = "controller.serviceAccount.name"
    value = var.service_account_name
  }

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.efs_csi_driver.arn
  }

  set {
    name = "node.serviceAccount.create"
    # We're using the same service account for both the nodes and controllers,
    # and we're already creating the service account in the controller config
    # above.
    value = "false"
  }

  set {
    name  = "node.serviceAccount.name"
    value = var.service_account_name
  }

  set {
    name  = "node.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.efs_csi_driver.arn
  }

  values = [
    yamlencode(var.settings)
  ]
}

# Install AWS Load baalncer Controller
resource "helm_release" "lb_controller" {
  depends_on = [var.mod_dependency, module.eks]
  name       = var.helm_chart_name_alb
  chart      = var.helm_chart_release_name_alb
  repository = var.helm_chart_repo_alb
  version    = var.helm_chart_version_alb
  namespace  = var.namespace

  set {
    name  = "clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = var.service_account_name_alb
  }
  
  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.lb_controller.arn
  }

  values = [
    yamlencode(var.settings)
  ]
}