# Enables all the APIs services used for
# the deployment

locals {
  _required_apis = [
    "compute.googleapis.com",
    "container.googleapis.com",
    "monitoring.googleapis.com",
    "logging.googleapis.com",
  ]
  _cloud_dns_api = var.google_services.use_cloud_dns ? ["dns.googleapis.com"] : []
  enable_apis    = concat(local._required_apis, local._cloud_dns_api)
}

resource "google_project_service" "openwisp_apis" {
  count                      = length(local.enable_apis)
  project                    = var.google_services.project_id
  service                    = local.enable_apis[count.index]
  disable_dependent_services = true
  disable_on_destroy         = var.google_services.disable_apis_on_destroy
}
