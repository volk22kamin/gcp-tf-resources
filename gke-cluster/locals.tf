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
        # Subnets are regional, so extract region from zone if needed
        # Format: projects/{project}/regions/{region}/subnetworks/{name}
        subnetwork = can(regex("^projects/", cluster.subnetwork)) ? cluster.subnetwork : (
          # Extract region from location (zone or region)
          # If location is a zone (e.g., us-central1-a), extract region (us-central1)
          # If location is already a region (e.g., us-central1), use it as-is
          "${local.subnetwork_base}/${
            can(regex("-[a-z]$", coalesce(cluster.location, var.gcp_region))) ?
            regex("^([a-z]+-[a-z]+[0-9]+)", coalesce(cluster.location, var.gcp_region))[0] :
            coalesce(cluster.location, var.gcp_region)
          }/subnetworks/${cluster.subnetwork}"
        )
      }
    )
  }
}
