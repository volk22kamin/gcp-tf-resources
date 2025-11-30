resource "google_compute_firewall" "default" {
  name        = var.name
  description = var.description
  network     = var.network
  project     = var.project_id

  dynamic "allow" {
    for_each = var.allow_rules
    content {
      protocol = allow.value.protocol
      ports    = allow.value.ports
    }
  }

  dynamic "deny" {
    for_each = var.deny_rules
    content {
      protocol = deny.value.protocol
      ports    = deny.value.ports
    }
  }

  source_ranges           = var.source_ranges
  source_tags             = var.source_tags
  target_tags             = var.target_tags
  target_service_accounts = var.target_service_accounts

  priority  = var.priority
  direction = var.direction
  disabled  = var.disabled

  dynamic "log_config" {
    for_each = var.log_config != null ? [var.log_config] : []
    content {
      metadata = log_config.value.metadata
    }
  }
}
