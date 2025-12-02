module "firewall" {
  source   = "./modules/firewall"
  for_each = var.firewall_rules

  name        = each.key
  description = try(each.value.description, null)
  network     = var.network
  project_id  = var.project_id

  allow_rules = try(each.value.allow_rules, [])
  deny_rules  = try(each.value.deny_rules, [])

  source_ranges           = try(each.value.source_ranges, null)
  source_tags             = try(each.value.source_tags, null)
  target_tags             = try(each.value.target_tags, null)
  target_service_accounts = try(each.value.target_service_accounts, null)

  priority   = try(each.value.priority, 1000)
  direction  = try(each.value.direction, "INGRESS")
  disabled   = try(each.value.disabled, false)
  log_config = try(each.value.log_config, null)
}
