project_id  = "terraform-480008"
environment = "main"
gcp_region  = "us-central1"

common_labels = {
  managed_by = "terraform"
  project    = "gke-infrastructure"
}

gke_clusters = {
  "primary-cluster" = {
    location = "us-central1-a"
    
    # Just pass the VPC and subnet names - module will construct full self-links
    network    = "main-k8s-vpc"
    subnetwork = "k8s-subnet-a"

    release_channel = "REGULAR"
    
    cluster_resource_labels = {
      environment = "main"
      cluster     = "primary"
    }

    # IP allocation policy for VPC-native cluster
    # These should match the secondary IP range names from your VPC subnet
    ip_allocation_policy = {
      cluster_secondary_range_name  = "pods"
      services_secondary_range_name = "services"
    }

    # Authorized networks for master access
    authorized_networks = [
      {
        name        = "allow-all"
        cidr_block  = "0.0.0.0/0"
        description = "Allow all (update for production)"
      }
    ]

    # Default settings for node pools
    default_disk_size_gb = 30
    default_disk_type    = "pd-standard"
    default_preemptible  = false
    default_auto_upgrade = true
    default_auto_repair  = true

    # Node pool with 3 nodes
    node_pools = {
      "default-pool" = {
        machine_type       = "e2-medium"
        min_count          = 3
        max_count          = 5
        initial_node_count = 3  # Start with 3 nodes
        disk_size_gb       = 30
        preemptible        = false
        labels = {
          pool = "default"
        }
        tags = ["gke-node", "default-pool"]
      }
    }

    deletion_protection = false  # Set to true for production
  }
}

