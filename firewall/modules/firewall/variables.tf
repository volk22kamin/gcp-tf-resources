variable "name" {
  description = "Name of the firewall rule"
  type        = string
}

variable "description" {
  description = "Description of the firewall rule"
  type        = string
  default     = null
}

variable "network" {
  description = "The network this rule applies to"
  type        = string
}

variable "project_id" {
  description = "The project ID"
  type        = string
}

variable "allow_rules" {
  description = "List of allow rules"
  type = list(object({
    protocol = string
    ports    = list(string)
  }))
  default = []
}

variable "deny_rules" {
  description = "List of deny rules"
  type = list(object({
    protocol = string
    ports    = list(string)
  }))
  default = []
}

variable "source_ranges" {
  description = "Source IP ranges"
  type        = list(string)
  default     = null
}

variable "source_tags" {
  description = "Source tags"
  type        = list(string)
  default     = null
}

variable "target_tags" {
  description = "Target tags"
  type        = list(string)
  default     = null
}

variable "target_service_accounts" {
  description = "Target service accounts"
  type        = list(string)
  default     = null
}

variable "priority" {
  description = "Priority of the rule"
  type        = number
  default     = 1000
}

variable "direction" {
  description = "Direction of the rule (INGRESS or EGRESS)"
  type        = string
  default     = "INGRESS"
}

variable "disabled" {
  description = "Whether the rule is disabled"
  type        = bool
  default     = false
}

variable "log_config" {
  description = "Log configuration"
  type = object({
    metadata = string
  })
  default = null
}
