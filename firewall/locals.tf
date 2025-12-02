locals {
  network_base = "projects/${var.project_id}/global/networks"

  # Transform firewall rules to use full network self-links
  # If network is specified in the rule, construct the full path
  # Otherwise, use the default network if provided
  firewall_rules_with_full_paths = {
    for rule_name, rule in var.firewall_rules : rule_name => merge(
      rule,
      {
        network = rule.network != null ? (
          # If network contains "projects/", assume it's already a full self-link
          can(regex("^projects/", rule.network)) ? rule.network : "${local.network_base}/${rule.network}"
          ) : (
          # Use default network if rule doesn't specify one
          var.network != null ? (
            can(regex("^projects/", var.network)) ? var.network : "${local.network_base}/${var.network}"
          ) : null
        )
      }
    )
  }
}
