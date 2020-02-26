# Output variables

The `five` output variables are documented below:

1\.  [infrastructure](#infrastructure)  
2\.  [openwisp_services](#openwisp_services)  
3\.  [ow_cluster_ready](#ow_cluster_ready)  
4\.  [ow_kubectl_ready](#ow_kubectl_ready)  
5\.  [ow_persistent_disk](#ow_persistent_disk)  

<a name="infrastructure"></a>

### 1\. infrastructure

Details about the infrastructure.

```
name                            : Name of the provider.
                                  Valid options are: ["google",]
http_loadbalancer_name          : Name of the http_loadbalancer. (Useful for annotations in kubernetes Ingress)
openvpn_loadbalancer_address    : IP Address to be assigned for openvpn kubernetes loadbalancer.
freeradius_loadbalancer_address : IP Address to be assigned for freeradius kubernetes loadbalancer.
cluster:
name                            : Name of the kubernetes cluster.
nodes_cidr_range                : Address range for pods.
pods_cidr_range                 : Address range for pods.
services_cidr_range             : Address range for ClusterIP services.
endpoint                        : Kubernetes cluster endpoint IP address. (example: 192.168.2.25)
ca_certificate                  : ca_certificate of the cluster that needs to be decoded in base64 for authentication.
access_token                    : Access token required for authentication to perform actions in the cluster.
database:
enabled                         : Flag for cloud provided database being used. (Like Google Cloud SQL)
sslmode                         : [PSQL database sslmodes](https://www.postgresql.org/docs/9.1/libpq-ssl.html)
ca_cert                         : Contents of the server certificate file
client_cert                     : Contents of the client certificate file
client_key                      : Contents of the client private key
username                        : Username to login to database
password                        : Password to login to database
name                            : Name of the database to be used by openwisp
host                            : IP address of the database server
```
<a name="openwisp_services"></a>

### 2\. openwisp_services

Flags for enabling/disabling OpenWISP services to be used.

```
use_openvpn    : (Boolean) Setup OpenVPN for management inside cluster.
use_freeradius : (Boolean) Setup freeradius inside cluster.
setup_database : (Boolean) Setup database inside cluster. You would want to
                    set this as false when you have your own database server or
                    you are using cloud SQL.
setup_fresh    : (Boolean) Flag to initial setup of openwisp. Only required when you
                    are setting up openwisp & openwisp-database for the first time.
```
<a name="ow_cluster_ready"></a>

### 3\. ow_cluster_ready

(Boolean) Resource creation starts when this signal is received, useful for other modules to report when cluster is ready for deployment.
<a name="ow_kubectl_ready"></a>

### 4\. ow_kubectl_ready

(Boolean) Signal for kubectl configured and ready on local machine.
<a name="ow_persistent_disk"></a>

### 5\. ow_persistent_disk

The values of the 'gce_persistent_disk' variable to be used by the kubernetes module.
