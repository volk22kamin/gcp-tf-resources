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

# VPC Networks Configuration - Dynamic Map
variable "vpc_networks" {
  description = "Map of VPC networks to create. Key is the network identifier."
  type = map(object({
    region = optional(string)
    subnets = list(object({
      name          = string
      ip_cidr_range = string
      secondary_ip_ranges = optional(list(object({
        range_name    = string
        ip_cidr_range = string
      })), [])
    }))
    enable_private_google_access = optional(bool, true)
    enable_cloud_nat             = optional(bool, false)
    nat_ip_allocate_option       = optional(string, "AUTO_ONLY")
    enable_nat_logging           = optional(bool, true)
    nat_log_filter               = optional(string, "ERRORS_ONLY")
  }))
  default = {}
}
