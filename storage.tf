# Persistent storage & backup for the cluster

resource "google_compute_resource_policy" "gce_data_disk_snapshot" {
  depends_on = [google_project_service.openwisp_apis]
  name       = var.gce_persistent_disk.snapshots.name
  snapshot_schedule_policy {
    schedule {
      hourly_schedule {
        hours_in_cycle = var.gce_persistent_disk.snapshots.hours_in_cycle
        start_time     = var.gce_persistent_disk.snapshots.start_time
      }
    }
    retention_policy {
      max_retention_days    = var.gce_persistent_disk.snapshots.retention_days
      on_source_disk_delete = var.gce_persistent_disk.snapshots.on_disk_deletion
    }
    snapshot_properties {
      labels = {
        app = "openwisp-disk"
      }
    }
  }
}

resource "google_compute_disk" "gce_persistent_disk" {
  provider          = google-beta
  name              = var.gce_persistent_disk.name
  type              = var.gce_persistent_disk.type
  size              = var.gce_persistent_disk.size
  description       = var.google_services.common_resource_description
  resource_policies = [google_compute_resource_policy.gce_data_disk_snapshot.name]
}

# (Optional) Cloud SQL

resource "google_sql_database_instance" "openwisp_db" {
  count            = var.google_services.use_cloud_sql ? 1 : 0
  provider         = google-beta
  depends_on       = [google_service_networking_connection.openwisp_internal_network]
  name             = var.database_cloudsql.name
  region           = var.google_services.region
  database_version = "POSTGRES_11"
  settings {
    tier = var.database_cloudsql.tier
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.openwisp_network.self_link
      require_ssl     = var.database_cloudsql.require_ssl
    }
    backup_configuration {
      enabled    = var.database_cloudsql.auto_backup.enabled
      start_time = var.database_cloudsql.auto_backup.start_time
    }
    maintenance_window {
      day          = var.database_cloudsql.maintaince.day
      hour         = var.database_cloudsql.maintaince.hour
      update_track = var.database_cloudsql.maintaince.track
    }
    location_preference {
      zone = var.google_services.zone
    }
    availability_type = var.database_cloudsql.availability_type
    disk_size         = var.database_cloudsql.disk_size
    disk_type         = var.database_cloudsql.disk_type
  }
}

resource "google_sql_user" "openwisp_cluster_user" {
  count    = var.google_services.use_cloud_sql ? 1 : 0
  name     = var.database_cloudsql.username
  instance = google_sql_database_instance.openwisp_db[0].name
  password = var.database_cloudsql.password
}

resource "google_sql_database" "openwisp_database" {
  count      = var.google_services.use_cloud_sql ? 1 : 0
  depends_on = [google_sql_user.openwisp_cluster_user, google_sql_ssl_cert.cluster_certificates]
  name       = var.database_cloudsql.database
  instance   = google_sql_database_instance.openwisp_db[0].name
}

resource "google_sql_ssl_cert" "cluster_certificates" {
  count       = var.google_services.use_cloud_sql ? 1 : 0
  depends_on  = [google_sql_user.openwisp_cluster_user]
  common_name = "terraform-openwisp-cluster"
  instance    = google_sql_database_instance.openwisp_db[0].name
}
