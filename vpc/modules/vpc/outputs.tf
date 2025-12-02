output "network_name" {
  description = "The name of the VPC network"
  value       = google_compute_network.vpc.name
}

output "network_id" {
  description = "The ID of the VPC network"
  value       = google_compute_network.vpc.id
}

output "network_self_link" {
  description = "The self-link of the VPC network"
  value       = google_compute_network.vpc.self_link
}

output "subnet_names" {
  description = "The names of the subnets"
  value       = [for s in google_compute_subnetwork.subnets : s.name]
}

output "subnet_ids" {
  description = "The IDs of the subnets"
  value       = { for s in google_compute_subnetwork.subnets : s.name => s.id }
}

output "subnet_self_links" {
  description = "The self-links of the subnets"
  value       = { for s in google_compute_subnetwork.subnets : s.name => s.self_link }
}

output "subnet_ip_cidr_ranges" {
  description = "The IP CIDR ranges of the subnets"
  value       = { for s in google_compute_subnetwork.subnets : s.name => s.ip_cidr_range }
}

output "router_name" {
  description = "The name of the Cloud Router (if created)"
  value       = var.enable_cloud_nat ? google_compute_router.router[0].name : null
}

output "nat_name" {
  description = "The name of the Cloud NAT (if created)"
  value       = var.enable_cloud_nat ? google_compute_router_nat.nat[0].name : null
}
