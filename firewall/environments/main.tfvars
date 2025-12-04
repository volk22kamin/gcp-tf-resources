project_id = "terraform-480008"
network = "default-vpc"

firewall_rules = {
  "allow-tcp-32000" = {
    network = "main-k8s-vpc"
    allow_rules = [{
      protocol = "tcp"
      ports    = ["32000", "32001", "30829"]
    }]
    source_ranges = [
      "0.0.0.0/0"
    ]
    priority    = 1000
    description = "Allow TCP on port 32000"
    target_tags = ["gke-node"]
  }
}
