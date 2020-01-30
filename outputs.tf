
# Data

data "google_client_config" "kubernetes_google_access" {}

# Locals

locals {
  _frlb  = var.openwisp_services.use_freeradius ? google_compute_address.openwisp_freeradius_ip[0].address : null
  _vpnlb = var.openwisp_services.use_openvpn ? google_compute_address.openwisp_openvpn_ip[0].address : null

  infrastructure_provider = {
    # Required for output, the kubernetes module expects the
    # following information from provider to function properly.
    name                            = "google"
    project                         = var.google_services.project_id
    use_cloud_database              = var.google_services.use_cloud_sql
    http_loadbalancer_name          = var.network_config.http_loadbalancer_ip_name
    openvpn_loadbalancer_address    = local._vpnlb
    freeradius_loadbalancer_address = local._frlb
    cluster = {
      name           = google_container_cluster.openwisp_cluster.name
      endpoint       = google_container_cluster.openwisp_cluster.endpoint
      ca_certificate = google_container_cluster.openwisp_cluster.master_auth[0].cluster_ca_certificate
      access_token   = data.google_client_config.kubernetes_google_access.access_token
    }
  }
}

# Output

output "infrastructure_provider" {
  value       = local.infrastructure_provider
  description = <<EOT
    Details about the infrastruture,
    name                            : (google) Name of the provider.
    use_cloud_database              : (Boolean) Flag for provider database being used.
    http_loadbalancer_name          : Name of the http_loadbalancer. (Useful for annotations in kubernetes Ingress)
    openvpn_loadbalancer_address    : IP Address to be assigned for openvpn kubernetes loadbalancer.
    freeradius_loadbalancer_address : IP Address to be assigned for freeradius kubernetes loadbalancer.
    cluster:
      name                          : Name of the kubernetes cluster.
      endpoint                      : Kubernetes cluster endpoint IP address. (example: 192.168.2.25)
      ca_certificate                : ca_certificate of the cluster that needs to be converted to base64 for authentication.
      access_token                  : Access token required for authentication to perform actions in the cluster.
  EOT
}

output "openwisp_services" {
  value       = var.openwisp_services
  description = "The values of the 'openwisp_services' variable to be used by the kubernetes module."
}

output "ow_persistent_disk" {
  value       = google_compute_disk.gce_persistent_disk
  description = "The values of the 'gce_persistent_disk' variable to be used by the kubernetes module."
}

output "ow_cluster_ready" {
  depends_on  = [google_container_node_pool.gke_node_groups]
  value       = true
  description = "(Boolean) Signal for status of cluster being ready for kubernetes to deploy resources."
}

output "ow_kubectl_ready" {
  depends_on  = [null_resource.configure_gcloud]
  value       = var.google_services.configure_gloud
  description = "(Boolean) Signal for status of kubectl being configured."
}
