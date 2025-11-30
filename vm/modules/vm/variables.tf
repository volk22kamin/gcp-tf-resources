# Core VM Configuration
variable "instance_name" {
  description = "Name of the VM instance"
  type        = string
}

variable "zone" {
  description = "GCP zone for the VM instance"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the VM instance (e.g., e2-medium, n1-standard-1)"
  type        = string
  default     = "e2-medium"
}

variable "description" {
  description = "Description of the VM instance"
  type        = string
  default     = ""
}

# Boot Disk Configuration
variable "boot_disk_image" {
  description = "Boot disk image (e.g., debian-cloud/debian-11, ubuntu-os-cloud/ubuntu-2204-lts)"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "boot_disk_size" {
  description = "Size of the boot disk in GB"
  type        = number
  default     = 10
}

variable "boot_disk_type" {
  description = "Type of boot disk (pd-standard, pd-ssd, pd-balanced)"
  type        = string
  default     = "pd-balanced"
}

variable "boot_disk_auto_delete" {
  description = "Whether the boot disk should be auto-deleted when the instance is deleted"
  type        = bool
  default     = true
}

# Additional Disks
variable "additional_disks" {
  description = "List of additional disks to attach to the instance"
  type = list(object({
    name        = string
    size        = number
    type        = string
    auto_delete = bool
  }))
  default = []
}

# Network Configuration
variable "network" {
  description = "Network to attach the instance to"
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "Subnetwork to attach the instance to"
  type        = string
  default     = null
}

variable "network_tier" {
  description = "Network tier for external IP (PREMIUM or STANDARD)"
  type        = string
  default     = "PREMIUM"
  validation {
    condition     = contains(["PREMIUM", "STANDARD"], var.network_tier)
    error_message = "Network tier must be either 'PREMIUM' or 'STANDARD'."
  }
}

variable "assign_external_ip" {
  description = "Whether to assign an external IP address"
  type        = bool
  default     = true
}

variable "external_ip_address" {
  description = "External IP address to assign (leave null for ephemeral)"
  type        = string
  default     = null
}

variable "network_tags" {
  description = "List of network tags to attach to the instance"
  type        = list(string)
  default     = []
}

# Metadata and Startup
variable "metadata" {
  description = "Metadata key-value pairs to assign to the instance"
  type        = map(string)
  default     = {}
}

variable "startup_script" {
  description = "Startup script to run when the instance boots"
  type        = string
  default     = null
}

variable "enable_ssh_keys" {
  description = "Whether to enable SSH keys from metadata"
  type        = bool
  default     = true
}

variable "ssh_keys" {
  description = "List of SSH keys in format 'user:ssh-rsa AAAAB3Nza...'"
  type        = list(string)
  default     = []
}

# Service Account
variable "service_account_email" {
  description = "Service account email to attach to the instance"
  type        = string
  default     = null
}

variable "service_account_scopes" {
  description = "List of service account scopes"
  type        = list(string)
  default     = ["cloud-platform"]
}

# Instance Configuration
variable "can_ip_forward" {
  description = "Whether to allow IP forwarding"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection"
  type        = bool
  default     = false
}

variable "enable_display" {
  description = "Whether to enable the display device"
  type        = bool
  default     = false
}

variable "allow_stopping_for_update" {
  description = "Whether to allow stopping the instance for updates"
  type        = bool
  default     = true
}

# Scheduling
variable "preemptible" {
  description = "Whether the instance is preemptible"
  type        = bool
  default     = false
}

variable "automatic_restart" {
  description = "Whether to automatically restart the instance if terminated"
  type        = bool
  default     = true
}

variable "on_host_maintenance" {
  description = "What to do when host maintenance occurs (MIGRATE or TERMINATE)"
  type        = string
  default     = "MIGRATE"
  validation {
    condition     = contains(["MIGRATE", "TERMINATE"], var.on_host_maintenance)
    error_message = "on_host_maintenance must be either 'MIGRATE' or 'TERMINATE'."
  }
}

# Labels and Tags
variable "labels" {
  description = "Map of labels to assign to the instance"
  type        = map(string)
  default     = {}
}

# Environment
variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_id" {
  description = "GCP project ID"
  type        = string
}

