project_id = "training-472512"
network    = "default"

firewall_rules = {
  # "allow-ssh-from-my-ip" = {
  #   allow_rules = [{
  #     protocol = "tcp"
  #     ports    = ["22"]
  #   }]
  #   source_ranges = ["93.173.240.78/32"]
  #   priority      = 1000
  #   description   = "Allow SSH from my IP"
  #   target_tags   = ["ssh"]
  # },
  "allow-5678-from-my-ip-and-github" = {
    allow_rules = [{
      protocol = "tcp"
      ports    = ["5678"]
    }]
    source_ranges = [
      "93.173.240.78/32",
      "140.82.112.0/20",
      "185.199.108.0/22",
      "192.30.252.0/22"
    ]
    priority      = 1000
    description   = "Allow port 5678 from my IP"
    target_tags   = ["n8n-server"]
  }
}
