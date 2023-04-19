locals {
  project_id = "${var.gpc_project_name}-${random_id.project_id.dec}"
}
data "google_folder" "mexico" {
  folder              = "folders/159560012336"
  lookup_organization = true
}

resource "random_id" "project_id" {
  byte_length = 8

}

resource "google_project" "this" {
  name            = var.gpc_project_name
  project_id      = local.project_id
  folder_id       = data.google_folder.mexico.name
  billing_account = "017CEA-5EBEBB-71C31C"
}

resource "google_project_service" "container" {
  depends_on = [
    google_project.this
  ]
  project = local.project_id
  service = "container.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

resource "google_project_service" "compute" {
  depends_on = [
    google_project.this
  ]
  project = local.project_id
  service = "container.googleapis.com"

  timeouts {
    create = "30m"
    update = "40m"
  }

  disable_dependent_services = true
}

output "org_id" {
  value = data.google_folder.mexico.organization
}
output "rand_id" {
  value = local.project_id
}