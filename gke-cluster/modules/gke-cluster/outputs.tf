output "cluster_name" {
  description = "Name of the created GKE cluster"
  value       = google_container_cluster.cluster.name
}

output "cluster_id" {
  description = "ID of the GKE cluster"
  value       = google_container_cluster.cluster.id
}

output "cluster_endpoint" {
  description = "Endpoint of the GKE control plane"
  value       = google_container_cluster.cluster.endpoint
}

output "cluster_master_version" {
  description = "Master version of the GKE cluster"
  value       = google_container_cluster.cluster.master_version
}

output "cluster_ca_certificate" {
  description = "Base64 encoded CA certificate for the cluster"
  value       = google_container_cluster.cluster.master_auth[0].cluster_ca_certificate
  sensitive   = true
}

output "node_pool_names" {
  description = "Names of the node pools created by the module"
  value       = keys(google_container_node_pool.pools)
}

output "node_pool_ids" {
  description = "IDs of the node pools"
  value       = { for k, v in google_container_node_pool.pools : k => v.id }
}
