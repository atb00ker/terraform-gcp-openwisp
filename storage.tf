# Persistent storage & backup for the cluster

resource "google_compute_disk" "gce_persistent_disk" {
  depends_on  = [google_project_service.openwisp_apis]
  name        = var.gce_persistent_disk.name
  type        = var.gce_persistent_disk.type
  size        = var.gce_persistent_disk.size
  description = var.google_services.common_resource_description
}
