# Output variables

- `infrastructure_provider`: Details about the infrastruture

```
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
```
- `openwisp_services`: The values of the 'openwisp_services' variable to be used by the kubernetes module."

- `ow_persistent_disk`: The values of the 'gce_persistent_disk' variable to be used by the kubernetes module."

- `ow_cluster_ready`: (Boolean) Signal for status of cluster being ready for kubernetes to deploy resources."

- `ow_kubectl_ready`: (Boolean) Signal for status of kubectl being configured."
