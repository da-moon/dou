terraform {
  backend "remote" {
    organization = "DoU-TFE"

    workspaces {
      name = "ibm-workspace-test"
    }
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.6.0"
    }
  }
}


provider "google" {
  credentials = file("ibm-lsf-test-.json")
  project     = "ibm-lsf-test"
  region      = "us-central1"
}

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "e2-medium"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }


  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

}