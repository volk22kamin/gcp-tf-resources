output "firewall_ids" {
  description = "Map of firewall rule IDs"
  value       = { for k, v in module.firewall : k => v.id }
}

output "firewall_self_links" {
  description = "Map of firewall rule self links"
  value       = { for k, v in module.firewall : k => v.self_link }
}
