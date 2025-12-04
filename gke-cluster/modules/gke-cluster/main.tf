
resource "google_container_cluster" "cluster" {
  project  = var.project_id
  name     = var.cluster_name
  location = var.location

  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.network
  subnetwork = var.subnetwork

  resource_labels = var.cluster_resource_labels

  deletion_protection = var.deletion_protection

  dynamic "release_channel" {
    for_each = var.release_channel != null ? [var.release_channel] : []
    content {
      channel = release_channel.value
    }
  }

  dynamic "master_authorized_networks_config" {
    for_each = length(var.authorized_networks) > 0 ? [var.authorized_networks] : []
    content {
      dynamic "cidr_blocks" {
        for_each = master_authorized_networks_config.value
        content {
          display_name = try(cidr_blocks.value.description, cidr_blocks.value.name)
          cidr_block   = cidr_blocks.value.cidr_block
        }
      }
    }
  }

  dynamic "private_cluster_config" {
    for_each = var.private_cluster_config.enable_private_nodes ? [var.private_cluster_config] : []
    content {
      enable_private_nodes    = true
      enable_private_endpoint = lookup(private_cluster_config.value, "enable_private_endpoint", false)
      master_ipv4_cidr_block  = lookup(private_cluster_config.value, "master_ipv4_cidr_block", null)

      dynamic "master_global_access_config" {
        for_each = lookup(private_cluster_config.value, "master_global_access", false) ? [1] : []
        content {
          enabled = true
        }
      }
    }
  }

  dynamic "ip_allocation_policy" {
    for_each = var.ip_allocation_policy != null ? [var.ip_allocation_policy] : []
    content {
      cluster_secondary_range_name  = lookup(ip_allocation_policy.value, "cluster_secondary_range_name", null)
      services_secondary_range_name = lookup(ip_allocation_policy.value, "services_secondary_range_name", null)
    }
  }

  lifecycle {
    ignore_changes = [remove_default_node_pool, initial_node_count]
  }
}

resource "google_container_node_pool" "pools" {
  for_each = var.node_pools

  project  = var.project_id
  location = var.location
  cluster  = google_container_cluster.cluster.name
  name     = each.key

  initial_node_count = each.value.initial_node_count
  node_locations     = try(length(each.value.node_locations), 0) > 0 ? each.value.node_locations : null

  node_config {
    machine_type    = each.value.machine_type
    disk_size_gb    = coalesce(each.value.disk_size_gb, var.default_disk_size_gb)
    disk_type       = coalesce(each.value.disk_type, var.default_disk_type)
    preemptible     = coalesce(each.value.preemptible, var.default_preemptible)
    service_account = each.value.service_account != null ? each.value.service_account : var.default_service_account
    oauth_scopes    = coalesce(each.value.oauth_scopes, var.default_oauth_scopes)

    labels   = each.value.labels != null ? each.value.labels : var.default_labels
    tags     = each.value.tags != null ? each.value.tags : var.default_tags
    metadata = each.value.metadata != null ? each.value.metadata : var.default_metadata
  }

  management {
    auto_upgrade = coalesce(each.value.auto_upgrade, var.default_auto_upgrade)
    auto_repair  = coalesce(each.value.auto_repair, var.default_auto_repair)
  }

  autoscaling {
    min_node_count = each.value.min_count
    max_node_count = each.value.max_count
  }
}
