variable node_image        { default = "ubuntu-os-cloud/ubuntu-1604-lts" }
variable node_machine_type { default = "n1-standard-4" }
variable node_zone         { default = "us-central1-a" }
variable node_network_id   { default = "node-network" }
variable node_count        { default = "1" }
variable node_owner        { default = "hum" }

module "node" {
  source = "../../modules/node"

  image        = "${var.node_image}"
  machine_type = "${var.node_machine_type}"
  zone         = "${var.node_zone}"
  network_id   = "${var.node_network_id}"
  count        = "${var.node_count}"

  owner        = "${var.node_owner}"
}
