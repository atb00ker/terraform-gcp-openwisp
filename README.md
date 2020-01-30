# Terraform-gcp-openwisp

[![Gitter](https://img.shields.io/badge/terraform-openwisp-blue)](https://registry.terraform.io/modules/atb00ker/openwisp/gcp/0.1.0-alpha.1)
[![GitHub license](https://img.shields.io/github/license/atb00ker/terraform-gcp-openwisp.svg)](https://github.com/openwisp/terraform-gcp-openwisp/blob/master/LICENSE)

Terraform files for deploying docker-openwisp infrastructure in Google Cloud.
This module creates the infrastructure required for deploying the
kubernetes cluster.

## Requirements

1. Create a Google Cloud service account that has atleast the following roles:

    - Compute Admin
    - Compute Network Admin
    - Compute Security Admin
    - Kubernetes Engine Admin
    - DNS Administrator
    - Service Account User
    - Service Usage Admin

2. Enable following APIs allow terraform to create resources:

   - [serviceusage.googleapis.com](https://console.developers.google.com/apis/api/serviceusage.googleapis.com)
   - [cloudresourcemanager.googleapis.com](https://console.developers.google.com/apis/library/cloudresourcemanager.googleapis.com)

## Usage

1. Configure the options in the module. (`examples/` may be helpful)
2. Apply the configurations: `terraform apply`
3. Destroy resources only required for management (Creation / Updation)

```bash
terraform destroy \
    --target=module.infrastructure.google_compute_router.openwisp_cluster_router \
    --target=module.infrastructure.google_compute_router_nat.openwisp_connection_nat
```

4. To set your domains with your registrar, find NS records [here](https://console.cloud.google.com/net-services/dns/zones/openwisp-dns).

The documentation for [input variables](docs/input.md) and [output variables](docs/output.md) might be useful as the one on [terraform registry](https://registry.terraform.io/modules/atb00ker/openwisp/gcp/0.1.0-alpha.1) is poorly formatted.
