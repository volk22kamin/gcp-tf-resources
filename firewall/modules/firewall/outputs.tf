output "id" {
  description = "The ID of the firewall rule"
  value       = google_compute_firewall.default.id
}

output "self_link" {
  description = "The self link of the firewall rule"
  value       = google_compute_firewall.default.self_link
}
