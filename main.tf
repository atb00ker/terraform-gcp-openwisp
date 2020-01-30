# Entry point for terraform.

terraform {
  required_version = "~> 0.12.6"
  required_providers {
    google = "~> 3.6"
    null   = "~> 2.1"
  }
}

provider "google" {
  credentials = var.google_services.service_account
  project     = var.google_services.project_id
  region      = var.google_services.region
  zone        = var.google_services.zone
}
