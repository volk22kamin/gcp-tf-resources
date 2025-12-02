# Production Environment Configuration
environment  = "prod"
gcp_region   = "us-east1"
gcp_zone     = "us-east1-c"
project_id   = "training-472512"
project_name = "vm-instances"

common_labels = {
  environment = "production"
  managed_by  = "terraform"
  project     = "vm-instances"
  cost_center = "production"
}

# VM Instances Configuration
vm_instances = {
  "n8n-server" = {
    machine_type    = "e2-micro"
    description     = "n8n automation server"
    boot_disk_image = "ubuntu-os-cloud/ubuntu-2204-lts"
    boot_disk_size  = 30
    boot_disk_type  = "pd-standard"

    assign_external_ip = true

    network_tags = ["http-server", "https-server", "ssh", "n8n-server"]

    startup_script = <<-EOF
      #!/bin/bash
      # Install Docker and Docker Compose
      apt-get update
      apt-get install -y ca-certificates curl gnupg
      install -m 0755 -d /etc/apt/keyrings
      curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
      chmod a+r /etc/apt/keyrings/docker.gpg
      echo \
        "deb [arch=\"$(dpkg --print-architecture)\" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null
      apt-get update
      apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
      
      # Start Docker
      systemctl enable docker
      systemctl start docker
    EOF

    labels = {
      role = "automation"
      app  = "n8n"
    }
  }
}
