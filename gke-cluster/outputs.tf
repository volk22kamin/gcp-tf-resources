output "gke_clusters" {
  description = "Map of GKE cluster details"
  value = {
    for key, cluster in module.gke_cluster : key => {
      cluster_name           = cluster.cluster_name
      cluster_id             = cluster.cluster_id
      cluster_endpoint       = cluster.cluster_endpoint
      cluster_master_version = cluster.cluster_master_version
      node_pool_names        = cluster.node_pool_names
      node_pool_ids          = cluster.node_pool_ids
    }
  }
}

output "cluster_endpoints" {
  description = "Map of cluster endpoints by cluster key"
  value       = { for key, cluster in module.gke_cluster : key => cluster.cluster_endpoint }
}

output "cluster_ca_certificates" {
  description = "Map of cluster CA certificates by cluster key"
  value       = { for key, cluster in module.gke_cluster : key => cluster.cluster_ca_certificate }
  sensitive   = true
}
