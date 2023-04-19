resource "google_compute_instance" "node" {
  name         = "node-${count.index}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"
  count        = "${var.count}"

  # machine image to use
  disk {
    image = "${var.image}"
    size = "40"
  }

  # network config
  network_interface {
    network = "${var.network_id}"
    
    access_config {
      // Ephemeral IP
    }
  }

  # metadata tagging
  metadata {
    owner = "${var.owner}"
}
    connection {
        user = "ubuntu"
        agent = true
        private_key = "${file("${var.ssh_key_name}.pem")}"
    }

    provisioner "remote-exec" {
        inline = [
            "git clone https://github.com/DigitalOnUs/automated_scripts.git",
            "cd automated_scripts ",
            "sudo sh startclustr.sh"
        ]
    }


}
