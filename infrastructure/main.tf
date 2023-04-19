provider digitalocean {
}

data "digitalocean_image" "jenkins" {
    name = "jenkins-image"
}

data "digitalocean_image" "vault" {
    name = "vault-image"
}

data "digitalocean_volume_snapshot" "jenkins_snapshot" {
  name_regex  = "jenkins*"
  region      = "${var.region}"
  most_recent = true
}


resource "digitalocean_volume" "jenkins_volume" {
  region      = "${var.region}"
  name        = "jenkins_volume"
  size        = "${data.digitalocean_volume_snapshot.jenkins_snapshot.min_disk_size}"
  snapshot_id = "${data.digitalocean_volume_snapshot.jenkins_snapshot.id}"
}

resource "digitalocean_ssh_key" "default" {
    name = "default"
    public_key = "${file("ssh/digitalKey.pub")}"
}

resource "digitalocean_droplet" "jenkins_droplet" {
    image  = "${data.digitalocean_image.jenkins.image}"
    name   = "JenkinsDroplet"
    region = "${var.region}"
    size   = "${var.droplet_size}"
    ssh_keys = ["${digitalocean_ssh_key.default.fingerprint}"]  
}

resource "digitalocean_volume_attachment" "foobar" {
  droplet_id = "${digitalocean_droplet.jenkins_droplet.id}"
  volume_id  = "${digitalocean_volume.jenkins_volume.id}"
}

resource "digitalocean_droplet" "vault_droplet" {
    image  = "${data.digitalocean_image.vault.image}"
    name   = "VaultDroplet"
    region = "${var.region}"
    size   = "${var.droplet_size}"
    ssh_keys = ["${digitalocean_ssh_key.default.fingerprint}"]
}
