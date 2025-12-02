module "gke_cluster" {
  for_each = local.gke_clusters_with_full_paths
  source   = "./modules/gke-cluster"

  project_id   = var.project_id
  cluster_name = "${var.environment}-${each.key}"
  location     = each.value.location != null ? each.value.location : var.gcp_region

  network    = each.value.network    # Now uses full self-link from locals
  subnetwork = each.value.subnetwork # Now uses full self-link from locals

  release_channel         = each.value.release_channel
  cluster_resource_labels = merge(var.common_labels, each.value.cluster_resource_labels)
  authorized_networks     = each.value.authorized_networks
  private_cluster_config  = each.value.private_cluster_config
  ip_allocation_policy    = each.value.ip_allocation_policy

  default_oauth_scopes    = each.value.default_oauth_scopes
  default_service_account = each.value.default_service_account
  default_disk_size_gb    = each.value.default_disk_size_gb
  default_disk_type       = each.value.default_disk_type
  default_preemptible     = each.value.default_preemptible
  default_metadata        = each.value.default_metadata
  default_labels          = merge(var.common_labels, each.value.default_labels)
  default_tags            = each.value.default_tags
  default_auto_upgrade    = each.value.default_auto_upgrade
  default_auto_repair     = each.value.default_auto_repair

  node_pools          = each.value.node_pools
  deletion_protection = each.value.deletion_protection
}
