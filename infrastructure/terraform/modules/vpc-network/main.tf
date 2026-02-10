resource "google_compute_network" "migration_vpc" {
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "migration_subnet" {
  name          = "${var.network_name}-subnet"
  ip_cidr_range = var.subnet_cidr
  region        = var.region
  network       = google_compute_network.migration_vpc.id
}

resource "google_compute_firewall" "allow_rdp" {
  name    = "${var.network_name}-allow-rdp"
  network = google_compute_network.migration_vpc.name

  allow {
    protocol = "tcp"
    ports    = ["3389"]
  }

  source_ranges = var.admin_ip_ranges
}

resource "google_compute_firewall" "internal_communication" {
  name    = "${var.network_name}-allow-internal"
  network = google_compute_network.migration_vpc.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  source_ranges = [var.subnet_cidr]
}
