module "vpc" {
  depends_on = [
    google_project_service.compute,
  ]
  source  = "terraform-google-modules/network/google"
  version = "~> 3.0"

  project_id   = local.project_id
  network_name = "${var.gpc_project_name}-network"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = "gke-subnet"
      subnet_ip             = "10.1.0.0/16"
      subnet_region         = var.region
      subnet_private_access = "true"
      description           = "private subnet"
    },
  ]
  secondary_ranges = {
    gke-subnet = [
      {
        range_name    = "services-range"
        ip_cidr_range = "192.168.0.0/22"
      },
      {
        range_name    = "pods-range"
        ip_cidr_range = "192.168.64.0/22"
      },
    ]
  }

  routes = [
    {
      name              = "egress-internet"
      description       = "route through IGW to access internet"
      destination_range = "0.0.0.0/0"
      tags              = "egress-inet"
      next_hop_internet = "true"
    },
  ]
}