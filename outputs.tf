
# Data

data "google_client_config" "kubernetes_google_access" {}

# Locals

locals {
  _frlb  = var.openwisp_services.use_freeradius ? google_compute_address.openwisp_freeradius_ip[0].address : null
  _vpnlb = var.openwisp_services.use_openvpn ? google_compute_address.openwisp_openvpn_ip[0].address : null

  infrastructure = {
    # Required for output, the kubernetes module expects the
    # following information from provider to function properly.
    name                            = "google"
    http_loadbalancer_name          = var.network_config.http_loadbalancer_ip_name
    openvpn_loadbalancer_address    = local._vpnlb
    freeradius_loadbalancer_address = local._frlb
    cluster = {
      name                = google_container_cluster.openwisp_cluster.name
      services_cidr_range = var.network_config.services_cidr_range
      pods_cidr_range     = var.network_config.pods_cidr_range
      nodes_cidr_range    = var.network_config.subnet_cidr
      endpoint            = google_container_cluster.openwisp_cluster.endpoint
      ca_certificate      = google_container_cluster.openwisp_cluster.master_auth[0].cluster_ca_certificate
      access_token        = data.google_client_config.kubernetes_google_access.access_token
    }
    database = {
      enabled     = var.google_services.use_cloud_sql
      sslmode     = var.database_cloudsql.sslmode
      ca_cert     = var.google_services.use_cloud_sql ? google_sql_ssl_cert.cluster_certificates[0].server_ca_cert : null
      client_cert = var.google_services.use_cloud_sql ? google_sql_ssl_cert.cluster_certificates[0].cert : null
      client_key  = var.google_services.use_cloud_sql ? google_sql_ssl_cert.cluster_certificates[0].private_key : null
      username    = var.google_services.use_cloud_sql ? google_sql_user.openwisp_cluster_user[0].name : "admin"
      password    = var.google_services.use_cloud_sql ? google_sql_user.openwisp_cluster_user[0].password : "admin"
      name        = var.google_services.use_cloud_sql ? google_sql_database.openwisp_database[0].name : "openwisp_db"
      host        = var.google_services.use_cloud_sql ? google_sql_database_instance.openwisp_db[0].private_ip_address : "postgres"
    }
  }
}

# Output

output "infrastructure" {
  value       = local.infrastructure
  description = "Find documentation here: https://github.com/atb00ker/terraform-gcp-openwisp/blob/master/docs/output.md"
}

output "openwisp_services" {
  value       = var.openwisp_services
  description = "Find documentation here: https://github.com/atb00ker/terraform-gcp-openwisp/blob/master/docs/output.md"
}

output "ow_persistent_disk" {
  value       = google_compute_disk.gce_persistent_disk
  description = "Find documentation here: https://github.com/atb00ker/terraform-gcp-openwisp/blob/master/docs/output.md"
}

output "ow_cluster_ready" {
  depends_on  = [google_container_node_pool.gke_node_groups]
  value       = true
  description = "Find documentation here: https://github.com/atb00ker/terraform-gcp-openwisp/blob/master/docs/output.md"
}

output "ow_kubectl_ready" {
  depends_on  = [null_resource.configure_gcloud]
  value       = var.google_services.configure_gloud
  description = "Find documentation here: https://github.com/atb00ker/terraform-gcp-openwisp/blob/master/docs/output.md"
}
