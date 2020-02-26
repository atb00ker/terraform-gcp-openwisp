# Contains all the variables used in this module.

variable "google_services" {
  type = object({
    service_account             = string
    project_id                  = string
    region                      = string
    zone                        = string
    common_resource_description = string
    configure_gloud             = bool
    disable_apis_on_destroy     = bool
    use_cloud_sql               = bool
    use_cloud_dns               = bool
  })
  description = "Find documentation here: https://github.com/atb00ker/terraform-gcp-openwisp/blob/master/docs/input.md"
}

variable "openwisp_services" {
  type = object({
    use_openvpn    = bool
    use_freeradius = bool
    setup_database = bool
    setup_fresh    = bool
  })
  description = "Find documentation here: https://github.com/atb00ker/terraform-gcp-openwisp/blob/master/docs/input.md"
}

variable "gce_persistent_disk" {
  type = object({
    name = string
    type = string
    size = number
    snapshots = object({
      name             = string
      hours_in_cycle   = string
      start_time       = string
      retention_days   = number
      on_disk_deletion = string
    })
  })
  description = "Find documentation here: https://github.com/atb00ker/terraform-gcp-openwisp/blob/master/docs/input.md"
}

variable "database_cloudsql" {
  type = object({
    name              = string
    tier              = string
    require_ssl       = bool
    availability_type = string
    disk_size         = number
    disk_type         = string
    sslmode           = string
    username          = string
    password          = string
    database          = string
    auto_backup = object({
      enabled    = bool
      start_time = string
    })
    maintaince = object({
      day   = number
      hour  = number
      track = string
    })
  })
  description = "Find documentation here: https://github.com/atb00ker/terraform-gcp-openwisp/blob/master/docs/input.md"
}

variable "network_config" {
  type = object({
    vpc_name                  = string
    subnet_cidr               = string
    pods_cidr_range           = string
    services_cidr_range       = string
    http_loadbalancer_ip_name = string
    openvpn_ip_name           = string
    freeradius_ip_name        = string
    openwisp_dns_zone_name    = string
    openwisp_dns_name         = string
    openwisp_dns_records_ttl  = number
    subnet_flowlogs = object({
      enable   = bool
      interval = string
      sampling = number
      metadata = string
    })
  })
  description = "Find documentation here: https://github.com/atb00ker/terraform-gcp-openwisp/blob/master/docs/input.md"
}

variable "gke_node_groups" {
  type = list(object({
    pool_name           = string
    initial_node_count  = number
    min_node_count      = number
    max_node_count      = number
    disk_size_gb        = number
    auto_repair         = bool
    auto_upgrade        = bool
    is_preemptible      = bool
    disk_type           = string
    instance_image_type = string
    oauth_scopes        = list(string)
    machine_type        = string
    enable_autoscaling  = bool
  }))
  description = "Find documentation here: https://github.com/atb00ker/terraform-gcp-openwisp/blob/master/docs/input.md"
}

variable "gke_cluster" {
  type = object({
    cluster_name             = string
    kubernetes_version       = string
    logging_service          = string
    monitoring_service       = string
    master_ipv4_cidr_block   = string
    regional                 = bool
    enable_private_endpoint  = bool
    daily_maintenance_window = string
    authorized_networks = list(object({
      display_name = string
      cidr_block   = string
    }))
  })
  description = "Find documentation here: https://github.com/atb00ker/terraform-gcp-openwisp/blob/master/docs/input.md"
}
