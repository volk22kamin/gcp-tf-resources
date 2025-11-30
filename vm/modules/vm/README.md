# GCP VM Terraform Module

This module creates and manages Google Compute Engine VM instances with comprehensive configuration options.

## Features

- **Flexible Machine Types**: Support for all GCP machine types
- **Boot Disk Configuration**: Customizable boot disk with various images and sizes
- **Additional Disks**: Attach multiple additional persistent disks
- **Network Configuration**: Full control over network interfaces, IPs, and tags
- **Metadata & Startup Scripts**: Custom metadata and startup scripts
- **Service Accounts**: Attach service accounts with custom scopes
- **Scheduling Options**: Support for preemptible instances and maintenance policies
- **Labels & Tags**: Comprehensive labeling and network tagging

## Usage

```hcl
module "vm" {
  source = "./modules/vm"

  instance_name = "my-vm-instance"
  zone          = "us-central1-a"
  project_id    = "my-gcp-project"

  machine_type     = "e2-medium"
  boot_disk_image  = "debian-cloud/debian-11"
  boot_disk_size   = 20

  network_tags = ["web-server", "ssh-allowed"]

  startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
  EOF

  labels = {
    application = "web"
    team        = "platform"
  }
}
```

## Variables

| Name                  | Description                    | Type         | Default                | Required |
| --------------------- | ------------------------------ | ------------ | ---------------------- | -------- |
| instance_name         | Name of the VM instance        | string       | -                      | yes      |
| zone                  | GCP zone for the VM instance   | string       | -                      | yes      |
| project_id            | GCP project ID                 | string       | -                      | yes      |
| machine_type          | Machine type (e.g., e2-medium) | string       | e2-medium              | no       |
| boot_disk_image       | Boot disk image                | string       | debian-cloud/debian-11 | no       |
| boot_disk_size        | Boot disk size in GB           | number       | 10                     | no       |
| boot_disk_type        | Boot disk type                 | string       | pd-balanced            | no       |
| additional_disks      | List of additional disks       | list(object) | []                     | no       |
| network               | Network to attach              | string       | default                | no       |
| subnetwork            | Subnetwork to attach           | string       | null                   | no       |
| assign_external_ip    | Assign external IP             | bool         | true                   | no       |
| network_tags          | Network tags                   | list(string) | []                     | no       |
| startup_script        | Startup script                 | string       | null                   | no       |
| service_account_email | Service account email          | string       | null                   | no       |
| preemptible           | Preemptible instance           | bool         | false                  | no       |
| labels                | Resource labels                | map(string)  | {}                     | no       |

## Outputs

| Name             | Description                       |
| ---------------- | --------------------------------- |
| instance_id      | ID of the compute instance        |
| instance_name    | Name of the compute instance      |
| self_link        | Self-link of the compute instance |
| internal_ip      | Internal IP address               |
| external_ip      | External IP address (if assigned) |
| current_status   | Current status of the instance    |
| additional_disks | Map of additional disk self-links |

## Examples

### Basic Web Server

```hcl
module "web_server" {
  source = "./modules/vm"

  instance_name = "web-server-01"
  zone          = "us-central1-a"
  project_id    = "my-project"
  machine_type  = "e2-small"

  network_tags = ["http-server", "https-server"]

  startup_script = file("${path.module}/scripts/install-nginx.sh")
}
```

### VM with Additional Disk

```hcl
module "data_server" {
  source = "./modules/vm"

  instance_name = "data-server-01"
  zone          = "us-central1-a"
  project_id    = "my-project"

  additional_disks = [
    {
      name        = "data-disk"
      size        = 100
      type        = "pd-ssd"
      auto_delete = false
    }
  ]
}
```

### Preemptible Instance

```hcl
module "batch_worker" {
  source = "./modules/vm"

  instance_name = "batch-worker-01"
  zone          = "us-central1-a"
  project_id    = "my-project"

  preemptible   = true
  machine_type  = "n1-standard-4"
}
```
