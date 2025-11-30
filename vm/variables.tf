# General Configuration
variable "gcp_region" {
  description = "GCP region for resources"
  type        = string
  default     = "us-central1"
}

variable "gcp_zone" {
  description = "GCP zone for resources"
  type        = string
  default     = "us-central1-a"
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "vm-instances"
}

# Common Labels
variable "common_labels" {
  description = "Common labels to apply to all resources"
  type        = map(string)
  default     = {}
}

# VM Instances Configuration - Dynamic Map
variable "vm_instances" {
  description = "Map of VM instances to create. Key is the instance name."
  type = map(object({
    zone            = optional(string)
    machine_type    = string
    description     = string
    boot_disk_image = optional(string, "debian-cloud/debian-11")
    boot_disk_size  = optional(number, 10)
    boot_disk_type  = optional(string, "pd-balanced")
    additional_disks = optional(list(object({
      name        = string
      size        = number
      type        = string
      auto_delete = bool
    })), [])
    network                = optional(string, "default")
    subnetwork             = optional(string, null)
    assign_external_ip     = optional(bool, true)
    network_tags           = optional(list(string), [])
    metadata               = optional(map(string), {})
    startup_script         = optional(string, null)
    service_account_email  = optional(string, null)
    service_account_scopes = optional(list(string), ["cloud-platform"])
    preemptible            = optional(bool, false)
    deletion_protection    = optional(bool, false)
    labels                 = optional(map(string), {})
  }))
  default = {}
}
