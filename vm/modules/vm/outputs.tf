# Instance Outputs
output "instance_id" {
  description = "ID of the compute instance"
  value       = google_compute_instance.this.instance_id
}

output "instance_name" {
  description = "Name of the compute instance"
  value       = google_compute_instance.this.name
}

output "self_link" {
  description = "Self-link of the compute instance"
  value       = google_compute_instance.this.self_link
}

output "zone" {
  description = "Zone where the instance is located"
  value       = google_compute_instance.this.zone
}

output "machine_type" {
  description = "Machine type of the instance"
  value       = google_compute_instance.this.machine_type
}

# Network Outputs
output "internal_ip" {
  description = "Internal IP address of the instance"
  value       = google_compute_instance.this.network_interface[0].network_ip
}

output "external_ip" {
  description = "External IP address of the instance (if assigned)"
  value       = length(google_compute_instance.this.network_interface[0].access_config) > 0 ? google_compute_instance.this.network_interface[0].access_config[0].nat_ip : null
}

output "network_interface" {
  description = "Network interface details"
  value       = google_compute_instance.this.network_interface[0]
}

# Status Outputs
output "current_status" {
  description = "Current status of the instance"
  value       = google_compute_instance.this.current_status
}

output "cpu_platform" {
  description = "CPU platform of the instance"
  value       = google_compute_instance.this.cpu_platform
}

# Disk Outputs
output "boot_disk_self_link" {
  description = "Self-link of the boot disk"
  value       = google_compute_instance.this.boot_disk[0].source
}

output "additional_disks" {
  description = "Map of additional disk names to their self-links"
  value       = { for k, v in google_compute_disk.additional : k => v.self_link }
}

# Service Account Output
output "service_account" {
  description = "Service account attached to the instance"
  value       = length(google_compute_instance.this.service_account) > 0 ? google_compute_instance.this.service_account[0].email : null
}

# Labels Output
output "labels" {
  description = "Labels assigned to the instance"
  value       = google_compute_instance.this.labels
}

