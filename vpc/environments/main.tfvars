project_id  = "terraform-480008"
environment = "main"
gcp_region  = "us-central1"

vpc_networks = {
  "k8s-vpc" = {
    region = "us-central1"
    subnets = [
      {
        name          = "k8s-subnet-a"
        ip_cidr_range = "10.0.1.0/24"
        secondary_ip_ranges = [
          {
            range_name    = "pods"
            ip_cidr_range = "10.1.0.0/16"
          },
          {
            range_name    = "services"
            ip_cidr_range = "10.2.0.0/16"
          }
        ]
      },
      {
        name          = "k8s-subnet-b"
        ip_cidr_range = "10.0.2.0/24"
        secondary_ip_ranges = []
      }
    ]
    enable_private_google_access = true
    enable_cloud_nat             = false
    nat_ip_allocate_option       = "AUTO_ONLY"
    enable_nat_logging           = true
    nat_log_filter               = "ERRORS_ONLY"
  }
}
