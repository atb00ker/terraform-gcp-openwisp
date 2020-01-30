# This is a sample configuration file. Read more
# about these options in the documentation.

module "infrastructure" {
  source  = "atb00ker/openwisp/gcp"
  version = "0.1.0-alpha.2"

  google_services = {
    service_account             = file("account.json")
    project_id                  = "example"
    region                      = "asia-south1"
    zone                        = "asia-south1-a"
    common_resource_description = "This resource is created by terraform for OpenWISP deployment."
    use_cloud_sql               = false
    use_cloud_dns               = true
    configure_gloud             = true
    disable_apis_on_destroy     = false
  }

  openwisp_services = {
    use_openvpn    = true
    use_freeradius = true
    setup_database = true
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
    }
  ]

  gce_persistent_disk = {
    # Persistent disk in which all the openwisp
    # Data is stored, this includes postfix storage, site
    # static content & user uploaded media (like floor plans)
    name = "openwisp-disk"
    type = "pd-standard"
    size = 10
  }

  gke_cluster = {
    # Configurations for your kubernetes cluster
    cluster_name             = "openwisp-cluster"
    kubernetes_version       = "1.14.9-gke.23"
    regional                 = false
    logging_service          = "logging.googleapis.com/kubernetes"
    monitoring_service       = "monitoring.googleapis.com/kubernetes"
    master_ipv4_cidr_block   = "172.16.0.48/28"
    enable_private_endpoint  = false
    daily_maintenance_window = "05:00"
    authorized_networks = [
      {
        display_name = "office-static-address"
        cidr_block   = "192.0.2.10/32"
      },
      {
        display_name = "developers-address-range"
        cidr_block   = "192.0.2.0/24"
      },
    ]
  }

  network_config = {
    # OpenWISP deployment network options
    vpc_name                      = "openwisp-network"
    subnet_cidr                   = "10.130.0.0/20"
    services_secondary_range_cidr = "10.0.0.0/14"
    cluster_secondary_range_cidr  = "10.100.0.0/14"
    http_loadbalancer_ip_name     = "openwisp-http-loadbalancer-ip"
    openvpn_ip_name               = "openwisp-openvpn-ip"
    freeradius_ip_name            = "openwisp-freeradius-ip"
    openwisp_dns_name             = "example.com"
    openwisp_dns_zone_name        = "openwisp-dns"
    openwisp_dns_records_ttl      = 300
    subnet_flowlogs = {
      enable   = true
      interval = "INTERVAL_10_MIN"
      sampling = 0.5
      metadata = "INCLUDE_ALL_METADATA"
    }
  }
}
