# Output variables

The `five` output variables are documented below:

1\.  [infrastructure_provider](#infrastructure_provider)
2\.  [openwisp_services](#openwisp_services)
3\.  [ow_cluster_ready](#ow_cluster_ready)
4\.  [ow_kubectl_ready](#ow_kubectl_ready)
5\.  [ow_persistent_disk](#ow_persistent_disk)

<a name="infrastructure_provider"></a>

### 1\. infrastructure_provider

Details about the infrastructure.

```
name                            : Name of the provider.
                                  Valid options are: ["google",]
http_loadbalancer_name          : Name of the http_loadbalancer. (Useful for annotations in kubernetes Ingress)
openvpn_loadbalancer_address    : IP Address to be assigned for openvpn kubernetes loadbalancer.
freeradius_loadbalancer_address : IP Address to be assigned for freeradius kubernetes loadbalancer.
cluster:
name                            : Name of the kubernetes cluster.
cluster_ip_range                : Address range for ClusterIP services.
pod_ip_range                    : Address range for pods.
endpoint                        : Kubernetes cluster endpoint IP address. (example: 192.168.2.25)
ca_certificate                  : ca_certificate of the cluster that needs to be converted to base64 for authentication.
access_token                    : Access token required for authentication to perform actions in the cluster.
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
