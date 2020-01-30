# Input variables

- `google_services`: Google Cloud configurations and services to be used deployment of
    all the resources.

```
service_account             : Link to the JSON credential file of the account.
project_id                  : Google Cloud Project ID.
region                      : Region for creating regional resources.
zone                        : Zone for creating zonal resources.
common_resource_description : Description to be added in all created resources.
configure_gloud             : (Boolean) Get credentials for the cluster automatically and
                                set them at "$HOME/.kube/config" to be used by kubectl.
                                If you want to use this option you must:
                                1. Download gcloud sdk on your machine.
                                2. Login with an account with permission to get the credentials for
                                the account. (The service account created for the script will work)
disable_apis_on_destroy     : (Boolean) Disable GCP services on destroy enabled for this deployment.
use_cloud_sql               : (Not available) Use Cloud SQL as database.
use_cloud_dns               : (Boolean) Use DNS for setting up the IP addresses with
                                domains to access OpenWISP.
```

- `openwisp_services`: Flags for OpenWISP services to be used.
```
use_openvpn    : (Boolean) Setup OpenVPN for management inside cluster.
use_freeradius : (Boolean) Setup freeradius inside cluster.
setup_database : (Boolean) Setup database inside cluster. You would want to
                    set this as false when you have your own database server or
                    you are using cloud SQL.
```

- `gce_persistent_disk`: Setup the compute disk that is used as persistent storage for data like: Media(Images), Static(JS/CSS), Database and Maintaince HTML.

```
name : https://www.terraform.io/docs/providers/google/r/compute_disk.html#name
type : https://www.terraform.io/docs/providers/google/r/compute_disk.html#type
size : https://www.terraform.io/docs/providers/google/r/compute_disk.html#size
```

- `network_config`: Configuration options for VPC network & Google Cloud Network resources for deployment.


```
vpc_name                      : Name of the Google Cloud VPC that will be created.
subnet_cidr                   : primary CIDR range of the subnet created in the region of the cluster.
cluster_secondary_range_cidr  : Secondary CIDR range used by the cluster for assigning pod IP addresses.
services_secondary_range_cidr : Secondary CIDR range used by the cluster for assigning services of ClusterIPs.
http_loadbalancer_ip_name     : Name of the http loadbalancer that will be used as Ingress in kubernetes resources.
openvpn_ip_name               : Name of the static IP address to be reserved for OpenVPN loadbalancer.
freeradius_ip_name            : Name of the static IP address to be reserved for freeradius loadbalancer.
openwisp_dns_zone_name        : Name for the DNS zone resource, created only when "use_cloud_dns" is set to true.
openwisp_dns_name             : Holds the list of domains to be resolved by the peered zone. (example: example.com)
openwisp_dns_records_ttl      : Time to live for all the records in the DNS Zone. (example: 300)
subnet_flowlogs:
  enable                      : (Boolean) Flag to enable flowlogs for the cluster subnet.
  interval                    : https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html#aggregation_interval
  sampling                    : https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html#flow_sampling
  metadata                    : https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html#metadata
```

- `gke_node_groups`: List of Google Kubernets Engine node pools

```
pool_name           = Name of the Node pool.
initial_node_count  = Initial of Compute VMs.
enable_autoscaling  = (Boolean) Flag to enable autoscaling on the node.
min_node_count      = Minimum allowed nodes.
max_node_count      = Maximum allowed nodes.
disk_size_gb        = Allocated disk space to each node.
disk_type           = Allocated disk type for each node.
auto_repair         = (Boolean) https://cloud.google.com/kubernetes-engine/docs/how-to/node-auto-repair
auto_upgrade        = (Boolean) https://cloud.google.com/kubernetes-engine/docs/how-to/node-auto-upgrades
is_preemptible      = (Boolean) Flag for Compute instances to be boolean.
instance_image_type = https://www.terraform.io/docs/providers/google/r/container_cluster.html#disk_type
machine_type        = https://www.terraform.io/docs/providers/google/r/container_cluster.html#machine_type
```

- `gke_cluster`: Google Kubernetes Engine cluster configuration.
```
cluster_name               : Name of the Cluster.
kubernetes_version         : kubernetes master version.
logging_service            : URL of the logging service.
monitoring_service         : URL of the monitoring service.
master_ipv4_cidr_block     : https://www.terraform.io/docs/providers/google/r/container_cluster.html#master_ipv4_cidr_block
regional                   : (Boolean) Flag to create a zonal or regional cluster.
enable_private_endpoint    : https://www.terraform.io/docs/providers/google/r/container_cluster.html#enable_private_endpoint
daily_maintenance_window   : https://www.terraform.io/docs/providers/google/r/container_cluster.html#daily_maintenance_window
authorized_networks (list):
  display_name             : https://www.terraform.io/docs/providers/google/r/container_cluster.html#display_name
  cidr_block               : https://www.terraform.io/docs/providers/google/r/container_cluster.html#cidr_block
```
