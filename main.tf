terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["free-vm"]
}

resource "google_compute_instance" "free_vm" {
  name         = "free-vm"
  machine_type = "e2-micro"
  zone         = var.zone

  tags = ["free-vm"]

  boot_disk {
    initialize_params {
      # Ubuntu 24.04 LTS
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
      size  = 30
      type  = "pd-standard"
    }
  }

  network_interface {
    network = "default"
    access_config {}  # assigns ephemeral external IP
  }

  metadata = {
    startup-script = file("${path.module}/startup.sh")
  }
}
