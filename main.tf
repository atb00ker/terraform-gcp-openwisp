# Entry point for terraform.

terraform {
  required_version = "~> 0.12.18"
  required_providers {
    google-beta = "~> 3.9.0"
    google      = "~> 3.9.0"
    null        = "~> 2.1.0"
  }
}

provider "google" {
  credentials = var.google_services.service_account
  project     = var.google_services.project_id
  region      = var.google_services.region
  zone        = var.google_services.zone
}

provider "google-beta" {
  credentials = var.google_services.service_account
  project     = var.google_services.project_id
  region      = var.google_services.region
  zone        = var.google_services.zone
}
