locals {
  description = var.description == null ? "Permissions for role assumption of ${var.role_name}" : var.description
}