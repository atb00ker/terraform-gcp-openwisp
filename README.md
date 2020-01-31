# Terraform(GCP): OpenWISP

[![Terraform](https://img.shields.io/badge/terraform-openwisp-blue)](https://registry.terraform.io/modules/atb00ker/openwisp/gcp)
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

3. If you using the following options, please follow the requirements as per the variable's documentation:

- `google_services.configure_gloud`

## Usage

**Note: The following links work only when you are viewing on github.com**

### Variables
- Inputs  documentation available [here](docs/input.md).
- Outputs documentation available [here](docs/output.md).

### Examples
- Standalone example available [here](examples/standalone).

### Create:

1. Configure the options in the module. (`examples/` may be helpful)
2. Apply the configurations: `terraform apply`
3. If using Cloud DNS, get the [NS records](https://console.cloud.google.com/net-services/dns/zones/openwisp-dns) and add them in your domain registrar records.
4. Destroy resources only required for management (Creation / Updation)

```bash
terraform destroy \
    --target=module.infrastructure.google_compute_router.openwisp_cluster_router \
    --target=module.infrastructure.google_compute_router_nat.openwisp_connection_nat
```

### Destroy:

Remember to use terraform when you want to destroy a resource created by terraform.
To destroy all resources: `terraform destroy`

## Contribute to documentation

Some of the parts of documentations are re-used from the [terraform-kubernetes-openwisp](https://github.com/atb00ker/terraform-kubernetes-openwisp) to reduce maintenance, changes need to made in that repository in such cases.

1. Install MarkdownPP: `pip install MarkdownPP`
2. Make changes in `docs/build/` directory.
3. To create documentation, in the root of repository:

```bash
markdown-pp docs/build/input.mdpp -o docs/input.md
markdown-pp docs/build/output.mdpp -o docs/output.md
```
