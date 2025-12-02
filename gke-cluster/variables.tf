# General Configuration
variable "gcp_region" {
  description = "Default GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod, main)"
  type        = string
  default     = "main"
}

# Common Labels
variable "common_labels" {
  description = "Common labels to apply to all resources"
  type        = map(string)
  default     = {}
}

# GKE Clusters Configuration - Dynamic Map
variable "gke_clusters" {
  description = "Map of GKE clusters to create. Key is the cluster identifier."
  type = map(object({
    location   = optional(string)
    network    = string
    subnetwork = string

    release_channel         = optional(string, "REGULAR")
    cluster_resource_labels = optional(map(string), {})

    authorized_networks = optional(list(object({
      name        = string
      cidr_block  = string
      description = optional(string)
    })), [])

    private_cluster_config = optional(object({
      enable_private_nodes    = bool
      enable_private_endpoint = optional(bool, false)
      master_ipv4_cidr_block  = optional(string)
      master_global_access    = optional(bool, false)
      }), {
      enable_private_nodes = false
    })

    ip_allocation_policy = optional(object({
      cluster_secondary_range_name  = optional(string)
      services_secondary_range_name = optional(string)
    }))

    default_oauth_scopes = optional(list(string), [
      "https://www.googleapis.com/auth/cloud-platform"
    ])
    default_service_account = optional(string)
    default_disk_size_gb    = optional(number, 100)
    default_disk_type       = optional(string, "pd-balanced")
    default_preemptible     = optional(bool, false)
    default_metadata = optional(map(string), {
      "disable-legacy-endpoints" = "true"
    })
    default_labels       = optional(map(string), {})
    default_tags         = optional(list(string), [])
    default_auto_upgrade = optional(bool, true)
    default_auto_repair  = optional(bool, true)

    node_pools = map(object({
      machine_type       = string
      min_count          = number
      max_count          = number
      initial_node_count = optional(number)
      disk_size_gb       = optional(number)
      disk_type          = optional(string)
      preemptible        = optional(bool)
      service_account    = optional(string)
      labels             = optional(map(string))
      tags               = optional(list(string))
      metadata           = optional(map(string))
      oauth_scopes       = optional(list(string))
      node_locations     = optional(list(string))
      auto_upgrade       = optional(bool)
      auto_repair        = optional(bool)
    }))

    deletion_protection = optional(bool, true)
  }))
  default = {}
}
