# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0-alpha.5] - 2020-04-03
### Added
- option: gke_node_groups.oauth_scopes
- support for Cloud SQL
- dependency: added google-beta provider
- auto-snapshots of openwisp-disk
- renamed output "infrastructure_provider" -> "infrastructure"

## [0.1.0-alpha.4] - 2020-02-12
### Changed
- module input: network_config.cluster_ip_range -> network_config.services_cidr_range
- module input: network_config.pod_ip_range -> network_config.pods_cidr_range
- module output: infrastructure_provider.cluster_ip_range -> infrastructure_provider.services_cidr_range
- module output: infrastructure_provider.pod_ip_range -> infrastructure_provider.pods_cidr_range
- updated terraform = "~> 0.12.18"
- proper version lock for google = "~> 3.8.0"
- proper version lock for null   = "~> 2.1.0"

## [0.1.0-alpha.3] - 2020-02-01
### Added
- module output: infrastructure_provider.cluster_ip_range
- module output: infrastructure_provider.pod_ip_range

### Removed
- module output: infrastructure_provider.project
- module output: infrastructure_provider.use_cloud_database

## [0.1.0-alpha.2] - 2020-01-31
- Basic setup of infrastructure requirement for using OpenWISP on Google Kubernetes Engine.
