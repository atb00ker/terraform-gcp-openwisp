# This file holds the GKE cluster definition
# and the node-pools' definitions of the cluster.

locals {
  cluster_location = var.gke_cluster.regional ? var.google_services.region : var.google_services.zone
}

resource "google_container_cluster" "openwisp_cluster" {
  depends_on         = [google_project_service.openwisp_apis]
  name               = var.gke_cluster.cluster_name
  node_version       = var.gke_cluster.kubernetes_version
  min_master_version = var.gke_cluster.kubernetes_version
  description        = var.google_services.common_resource_description

  # Management
  maintenance_policy {
    daily_maintenance_window {
      start_time = var.gke_cluster.daily_maintenance_window
    }
  }

  # Logging & Monitoring
  logging_service    = var.gke_cluster.logging_service
  monitoring_service = var.gke_cluster.monitoring_service

  # Default Node Pool
  remove_default_node_pool = true
  initial_node_count       = 1

  # Network
  location   = local.cluster_location
  network    = google_compute_network.openwisp_network.self_link
  subnetwork = google_compute_subnetwork.openwisp_network_cluster_subnet.self_link

  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = [for block in var.gke_cluster.authorized_networks : {
        name = block.display_name
        cidr = block.cidr_block
      }]
      content {
        display_name = cidr_blocks.value.name
        cidr_block   = cidr_blocks.value.cidr
      }
    }
  }

  private_cluster_config {
    enable_private_nodes    = true
    master_ipv4_cidr_block  = var.gke_cluster.master_ipv4_cidr_block
    enable_private_endpoint = var.gke_cluster.enable_private_endpoint
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "cluster-pods-ip-range"
    services_secondary_range_name = "cluster-services-ip-range"
  }
}

resource "google_container_node_pool" "gke_node_groups" {
  count              = length(var.gke_node_groups)
  name               = var.gke_node_groups[count.index].pool_name
  cluster            = google_container_cluster.openwisp_cluster.name
  initial_node_count = var.gke_node_groups[count.index].initial_node_count

  dynamic "autoscaling" {
    # For loop hack to make autoscaling optional, there may be a
    # better way in the future terrform releases.
    for_each = var.gke_node_groups[count.index].enable_autoscaling ? [1] : []
    content {
      min_node_count = var.gke_node_groups[count.index].min_node_count
      max_node_count = var.gke_node_groups[count.index].max_node_count
    }
  }

  management {
    auto_repair  = var.gke_node_groups[count.index].auto_repair
    auto_upgrade = var.gke_node_groups[count.index].auto_upgrade
  }

  node_config {
    preemptible  = var.gke_node_groups[count.index].is_preemptible
    disk_size_gb = var.gke_node_groups[count.index].disk_size_gb
    disk_type    = var.gke_node_groups[count.index].disk_type
    image_type   = var.gke_node_groups[count.index].instance_image_type
    machine_type = var.gke_node_groups[count.index].machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
