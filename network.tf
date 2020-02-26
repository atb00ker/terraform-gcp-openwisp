# This file will create an isolated network for OpenWISP
# deployment and services related to the network

resource "google_compute_network" "openwisp_network" {
  depends_on              = [google_project_service.openwisp_apis]
  name                    = var.network_config.vpc_name
  auto_create_subnetworks = false
  description             = var.google_services.common_resource_description
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "openwisp_network_cluster_subnet" {
  name                     = "openwisp-cluster-subnet"
  ip_cidr_range            = var.network_config.subnet_cidr
  network                  = google_compute_network.openwisp_network.self_link
  region                   = var.google_services.region
  description              = var.google_services.common_resource_description
  private_ip_google_access = true

  # Secondary IP ranges required for the kubernetes cluster
  secondary_ip_range {
    range_name    = "cluster-pods-ip-range"
    ip_cidr_range = var.network_config.pods_cidr_range
  }

  secondary_ip_range {
    range_name    = "cluster-services-ip-range"
    ip_cidr_range = var.network_config.services_cidr_range
  }

  dynamic "log_config" {
    # For loop hack to make autoscaling optional, there may be a
    # better way in the future terrform releases.
    for_each = var.network_config.subnet_flowlogs.enable ? [1] : []
    content {
      aggregation_interval = var.network_config.subnet_flowlogs.interval
      flow_sampling        = var.network_config.subnet_flowlogs.sampling
      metadata             = var.network_config.subnet_flowlogs.metadata
    }
  }
}

resource "google_compute_firewall" "openwisp_network_allow_internal" {
  name          = "openwisp-network-allow-internal"
  network       = google_compute_network.openwisp_network.name
  description   = "${var.google_services.common_resource_description} It allows connections from any source in the network IP range to any instance on the network using all protocols."
  direction     = "INGRESS"
  priority      = 65534
  source_ranges = [var.network_config.subnet_cidr]
  allow { protocol = "all" }
}

# Reserve static IP

resource "google_compute_project_default_network_tier" "ensure_premium_network_tier" {
  depends_on   = [google_project_service.openwisp_apis]
  network_tier = "PREMIUM"
}

resource "google_compute_global_address" "openwisp_http_loadbalancer_ip" {
  depends_on   = [google_compute_project_default_network_tier.ensure_premium_network_tier]
  name         = var.network_config.http_loadbalancer_ip_name
  description  = var.google_services.common_resource_description
  address_type = "EXTERNAL"
}

resource "google_compute_address" "openwisp_freeradius_ip" {
  count        = var.openwisp_services.use_freeradius ? 1 : 0
  name         = var.network_config.freeradius_ip_name
  description  = var.google_services.common_resource_description
  address_type = "EXTERNAL"
}

resource "google_compute_address" "openwisp_openvpn_ip" {
  count        = var.openwisp_services.use_openvpn ? 1 : 0
  name         = var.network_config.openvpn_ip_name
  description  = var.google_services.common_resource_description
  address_type = "EXTERNAL"
}

# (Optional) Cloud DNS

resource "google_dns_managed_zone" "openwisp_dns" {
  depends_on  = [google_project_service.openwisp_apis]
  count       = var.google_services.use_cloud_dns ? 1 : 0
  name        = var.network_config.openwisp_dns_zone_name
  description = var.google_services.common_resource_description
  dns_name    = "${var.network_config.openwisp_dns_name}."
}

resource "google_dns_record_set" "openwisp_dns_records" {
  # Create DNS records for all the openwisp subdomains
  # that attach to the global http loadbalancer
  for_each = var.google_services.use_cloud_dns ? {
    0 : "controller"
    1 : "dashboard"
    2 : "topology"
    3 : "radius"
  } : {}
  name         = "${each.value}.${google_dns_managed_zone.openwisp_dns[0].dns_name}"
  managed_zone = google_dns_managed_zone.openwisp_dns[0].name
  rrdatas      = [google_compute_global_address.openwisp_http_loadbalancer_ip.address]
  ttl          = var.network_config.openwisp_dns_records_ttl
  type         = "A"
}

resource "google_dns_record_set" "freeradius_dns_record" {
  count        = var.google_services.use_cloud_dns && var.openwisp_services.use_freeradius ? 1 : 0
  name         = "freeradius.${google_dns_managed_zone.openwisp_dns[0].dns_name}"
  managed_zone = google_dns_managed_zone.openwisp_dns[0].name
  rrdatas      = [google_compute_address.openwisp_freeradius_ip[0].address]
  ttl          = var.network_config.openwisp_dns_records_ttl
  type         = "A"
}

resource "google_dns_record_set" "openvpn_dns_records" {
  count        = var.google_services.use_cloud_dns && var.openwisp_services.use_openvpn ? 1 : 0
  name         = "openvpn.${google_dns_managed_zone.openwisp_dns[0].dns_name}"
  managed_zone = google_dns_managed_zone.openwisp_dns[0].name
  rrdatas      = [google_compute_address.openwisp_openvpn_ip[0].address]
  ttl          = var.network_config.openwisp_dns_records_ttl
  type         = "A"
}


# (Optional) Cloud SQL

resource "google_compute_global_address" "service_networking_address" {
  depends_on    = [google_project_service.openwisp_apis]
  count         = var.google_services.use_cloud_sql ? 1 : 0
  name          = "service-networking-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.openwisp_network.self_link
}

resource "google_service_networking_connection" "openwisp_internal_network" {
  depends_on              = [google_project_service.openwisp_apis]
  count                   = var.google_services.use_cloud_sql ? 1 : 0
  network                 = google_compute_network.openwisp_network.self_link
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.service_networking_address[0].name]
}
