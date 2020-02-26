# This is a sample configuration file. Read more
# about these options in the documentation.

module "infrastructure" {
  source  = "atb00ker/openwisp/gcp"
  version = "0.1.0-alpha.5"

  google_services = {
    service_account             = file("account.json")
    project_id                  = "sample"
    region                      = "asia-south1"
    zone                        = "asia-south1-a"
    configure_gloud             = true
    common_resource_description = "This resource is created by terraform for OpenWISP deployment."
    use_cloud_sql               = false
    use_cloud_dns               = false
    disable_apis_on_destroy     = false
  }

  openwisp_services = {
    use_openvpn    = false
    use_freeradius = true
    setup_database = true
    setup_fresh    = true
  }

  gke_node_groups = [
    {
      pool_name           = "primary-instance-pool"
      enable_autoscaling  = true
      initial_node_count  = 2
      min_node_count      = 2
      max_node_count      = 5
      auto_repair         = true
      auto_upgrade        = false
      is_preemptible      = false
      disk_size_gb        = 10
      disk_type           = "pd-standard"
      instance_image_type = "COS"
      machine_type        = "n1-standard-1"
      oauth_scopes = [
        "https://www.googleapis.com/auth/monitoring",
        "https://www.googleapis.com/auth/logging.write",
      ]
      }, {
      pool_name           = "preemptible-instance-pool"
      enable_autoscaling  = false
      initial_node_count  = 1
      min_node_count      = 1
      max_node_count      = 10
      auto_repair         = true
      auto_upgrade        = false
      is_preemptible      = true
      disk_size_gb        = 10
      disk_type           = "pd-standard"
      instance_image_type = "COS"
      machine_type        = "n1-standard-1"
      oauth_scopes        = []
    }
  ]

  gce_persistent_disk = {
    # Persistent disk in which all the openwisp
    # Data is stored, this includes postfix storage, site
    # static content & user uploaded media (like floor plans)
    name = "openwisp-disk"
    type = "pd-standard"
    size = 10
    snapshots = {
      name             = "openwisp-snapshots"
      hours_in_cycle   = 6
      start_time       = "03:00"
      retention_days   = 10
      on_disk_deletion = "KEEP_AUTO_SNAPSHOTS"
    }
  }

  gke_cluster = {
    # Configurations for your kubernetes cluster
    cluster_name             = "openwisp-cluster"
    kubernetes_version       = "1.14.9-gke.23"
    regional                 = false
    logging_service          = "logging.googleapis.com/kubernetes"
    monitoring_service       = "monitoring.googleapis.com/kubernetes"
    master_ipv4_cidr_block   = "172.16.0.48/28"
    enable_private_nodes     = true
    enable_private_endpoint  = false
    daily_maintenance_window = "05:00"
    authorized_networks = [
      {
        display_name = "office-static-address"
        cidr_block   = "192.0.2.10/32"
      },
    ]
  }

  database_cloudsql = {
    name              = "openwisp-cloudsql-instance01"
    tier              = "db-f1-micro"
    username          = "admin"
    password          = "admin"
    database          = "openwisp_db"
    require_ssl       = false
    sslmode           = "disable"
    availability_type = "ZONAL"
    disk_size         = 10
    disk_type         = "PD_HDD"
    auto_backup = {
      enabled    = true
      start_time = "00:00"
    }
    maintaince = {
      day   = 7
      hour  = 3
      track = "stable"
    }
  }

  network_config = {
    # OpenWISP deployment network options
    vpc_name                  = "openwisp-network"
    subnet_cidr               = "10.130.0.0/20"
    services_cidr_range       = "10.0.0.0/14"
    pods_cidr_range           = "10.100.0.0/14"
    http_loadbalancer_ip_name = "openwisp-http-loadbalancer-ip"
    openvpn_ip_name           = "openwisp-openvpn-ip"
    freeradius_ip_name        = "openwisp-freeradius-ip"
    openwisp_dns_name         = "atb00ker.tk"
    openwisp_dns_zone_name    = "openwisp-dns"
    openwisp_dns_records_ttl  = 300
    subnet_flowlogs = {
      enable   = true
      interval = "INTERVAL_10_MIN"
      sampling = 0.5
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
}
