locals {
  network_base    = "projects/${var.project_id}/global/networks"
  subnetwork_base = "projects/${var.project_id}/regions"

  # Transform GKE clusters to use full network/subnetwork self-links
  gke_clusters_with_full_paths = {
    for cluster_name, cluster in var.gke_clusters : cluster_name => merge(
      cluster,
      {
        # Convert network name to full self-link if needed
        network = can(regex("^projects/", cluster.network)) ? cluster.network : "${local.network_base}/${cluster.network}"

        # Convert subnetwork name to full self-link if needed
        # Format: projects/{project}/regions/{region}/subnetworks/{name}
        subnetwork = can(regex("^projects/", cluster.subnetwork)) ? cluster.subnetwork : (
          # Extract region from location or use default
          "${local.subnetwork_base}/${coalesce(cluster.location, var.gcp_region)}/subnetworks/${cluster.subnetwork}"
        )
      }
    )
  }
}
