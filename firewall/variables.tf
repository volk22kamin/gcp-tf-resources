variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "network" {
  description = "Default network for firewall rules (can be overridden per rule)"
  type        = string
  default     = null
}

variable "firewall_rules" {
  description = "Map of firewall rules"
  type = map(object({
    network     = optional(string)
    description = optional(string)
    allow_rules = optional(list(object({
      protocol = string
      ports    = list(string)
    })), [])
    deny_rules = optional(list(object({
      protocol = string
      ports    = list(string)
    })), [])
    source_ranges           = optional(list(string))
    source_tags             = optional(list(string))
    target_tags             = optional(list(string))
    target_service_accounts = optional(list(string))
    priority                = optional(number)
    direction               = optional(string)
    disabled                = optional(bool)
    log_config = optional(object({
      metadata = string
    }))
  }))
  default = {}
}
