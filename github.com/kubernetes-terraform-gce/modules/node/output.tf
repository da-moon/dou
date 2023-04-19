output "node_instance_id" { value = ["${google_compute_instance.node.*.id}"] }
output "node_ip" { value = ["${google_compute_instance.node.*.network_interface.0.address}"] }
