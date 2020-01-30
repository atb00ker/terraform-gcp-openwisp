# Resource that need to be created only
# for management purposes and then destroyed.

resource "google_compute_router" "openwisp_cluster_router" {
  name        = "openwisp-management-router"
  network     = google_compute_network.openwisp_network.self_link
  description = "${var.google_services.common_resource_description}. This router is only required during deployment and maintainance and can be removed when openwisp is functioning in production."
}

resource "google_compute_router_nat" "openwisp_connection_nat" {
  name                               = "openwisp-management-nat"
  router                             = google_compute_router.openwisp_cluster_router.name
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name                    = google_compute_subnetwork.openwisp_network_cluster_subnet.self_link
    source_ip_ranges_to_nat = ["PRIMARY_IP_RANGE"]
  }

  log_config {
    enable = true
    filter = "ALL"
  }
}
