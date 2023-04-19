resource "google_compute_network" "node-network" {
  name                    = "${var.network_name}"
  auto_create_subnetworks = true
}
