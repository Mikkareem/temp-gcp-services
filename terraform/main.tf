terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.38.0"
    }
  }
}

provider "google" {
  project = var.project
  region = var.region
}

variable project {
  type = string
  default = "howzapp-techullurgy-full"
}

variable region {
  type = string
  default = "us-central1"
}

variable machine_type {
  type = string
  default = "e2-micro"
}

variable machine_image {
  type = string
  default = "projects/debian-cloud/global/images/debian-12-bookworm-arm64-v20250812"
}

variable "disk_type" {
  type = string
  default = "pd-standard"
}

variable "disk_size" {
  type = number
  default = 10
}

variable "app_docker_image" {
  type = string
}

variable "ssh_user" {
  type = string
  default = "app_user"
}

variable "ssh_private_key_path" {
  type = string
}

resource "google_compute_firewall" "allow_app_ports" {
  name    = "allow_app_ports"
  description = "Listening Ports for the application"

  network = "default"

  allow {
    protocol = "tcp"
    ports = ["80", "15672"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags = ["app-ports"]
}

resource "google_compute_instance" "app_server" {
  name = "app_server"
  machine_type = var.machine_type

  metadata = {
    ssh-keys = "${var.ssh_user}:${file("${var.ssh_private_key_path}.pub")}"
  }

  boot_disk {
    device_name = "app_server"

    initialize_params {
      image = var.machine_image
      size = var.disk_size
      type = var.disk_type
    }
  }

  network_interface {
    network = "default"
    access_config {
      network_tier = "STANDARD"
    }
  }

  tags = ["app-ports"]

  connection {
    type = "ssh"
    user = var.ssh_user
    private_key = var.ssh_private_key_path
    host = self.network_interface.0.access_config.0.nat_ip
  }

  provisioner "file" {
    source = "scripts/server.sh"
    destination = "/tmp/server.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "#!/bin/bash",
      "APP_DOCKER_IMAGE=${var.app_docker_image}",
      "sudo chmod +x /tmp/server.sh",
      "/tmp/server.sh"
    ]
  }
}
