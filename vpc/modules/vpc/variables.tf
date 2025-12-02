variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "network_name" {
  description = "The name of the VPC network"
  type        = string
}

variable "region" {
  description = "The GCP region for regional resources"
  type        = string
}

variable "subnets" {
  description = "A list of subnets to create"
  type = list(object({
    name          = string
    ip_cidr_range = string
    secondary_ip_ranges = optional(list(object({
      range_name    = string
      ip_cidr_range = string
    })), [])
  }))
  default = []
}

variable "enable_private_google_access" {
  description = "Enable private Google access for subnets"
  type        = bool
  default     = true
}

variable "enable_cloud_nat" {
  description = "Enable Cloud NAT for the VPC"
  type        = bool
  default     = false
}

variable "nat_ip_allocate_option" {
  description = "NAT IP allocation option (AUTO_ONLY or MANUAL_ONLY)"
  type        = string
  default     = "AUTO_ONLY"
  validation {
    condition     = contains(["AUTO_ONLY", "MANUAL_ONLY"], var.nat_ip_allocate_option)
    error_message = "nat_ip_allocate_option must be either 'AUTO_ONLY' or 'MANUAL_ONLY'."
  }
}

variable "enable_nat_logging" {
  description = "Enable logging for Cloud NAT"
  type        = bool
  default     = true
}

variable "nat_log_filter" {
  description = "Log filter for Cloud NAT (ERRORS_ONLY, TRANSLATIONS_ONLY, ALL)"
  type        = string
  default     = "ERRORS_ONLY"
  validation {
    condition     = contains(["ERRORS_ONLY", "TRANSLATIONS_ONLY", "ALL"], var.nat_log_filter)
    error_message = "nat_log_filter must be one of: ERRORS_ONLY, TRANSLATIONS_ONLY, ALL."
  }
}
