project_id = "training-472512"
network    = "default"

firewall_rules = {
  "allow-ssh-form-console" = {
    allow_rules = [{
      protocol = "tcp"
      ports    = ["22"]
    }]
    source_ranges = [
      "130.211.0.0/22",
      "35.191.0.0/16",
      "35.235.240.0/20"
    ]
    priority      = 100
    description   = "Allow SSH from GCP Console"
  }
  "allow-cloudflare-ipv4" = {
    allow_rules = [{
      protocol = "tcp"
      ports    = ["80", "443"]
    }]
    source_ranges = [
      "103.21.244.0/22",
      "103.22.200.0/22",
      "103.31.4.0/22",
      "104.16.0.0/13",
      "104.24.0.0/14",
      "108.162.192.0/18",
      "131.0.72.0/22",
      "141.101.64.0/18",
      "162.158.0.0/15",
      "172.64.0.0/13",
      "173.245.48.0/20",
      "188.114.96.0/20",
      "190.93.240.0/20",
      "197.234.240.0/22",
      "198.41.128.0/17",
    ]
    priority      = 998
    description   = "Allow HTTP and HTTPS from Cloudflare IPv4"
    target_tags   = ["n8n-server"]
  }

  "allow-cloudflare-ipv6" = {
    allow_rules = [{
      protocol = "tcp"
      ports    = ["80", "443"]
    }]
    source_ranges = [
      "2400:cb00::/32",
      "2405:8100::/32",
      "2405:b500::/32",
      "2606:4700::/32",
      "2803:f800::/32",
      "2a06:98c0::/29",
      "2c0f:f248::/32",
    ]
    priority      = 998
    description   = "Allow HTTP and HTTPS from Cloudflare IPv6"
    target_tags   = ["n8n-server"]
  }

  "deny-all-from-internet" = {
    deny_rules = [{
      protocol = "all"
      ports    = []
    }]
    source_ranges = [
      "0.0.0.0/0"
    ]
    priority      = 999
    description   = "Deny all remaining ingress from the internet to n8n"
    target_tags   = ["n8n-server"]
  }
  "deny-all-from-internet-ipv6" = {
    deny_rules = [{
      protocol = "all"
      ports    = []
    }]
    source_ranges = [
      "::/0",
    ]
    priority      = 999
    description   = "Deny all remaining ingress from the internet to n8n over IPv6"
    target_tags   = ["n8n-server"]
  }
}
