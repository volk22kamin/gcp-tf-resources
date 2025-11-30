# Additional Disks (created separately)
resource "google_compute_disk" "additional" {
  for_each = { for idx, disk in var.additional_disks : disk.name => disk }

  name = "${var.instance_name}-${each.value.name}"
  type = each.value.type
  zone = var.zone
  size = each.value.size

  labels = merge(
    var.labels,
    {
      instance    = var.instance_name
      environment = var.environment
      managed_by  = "terraform"
    }
  )

  project = var.project_id
}

# Compute Instance
resource "google_compute_instance" "this" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  description  = var.description

  can_ip_forward            = var.can_ip_forward
  deletion_protection       = var.deletion_protection
  enable_display            = var.enable_display
  allow_stopping_for_update = var.allow_stopping_for_update

  tags = var.network_tags

  # Boot Disk
  boot_disk {
    auto_delete = var.boot_disk_auto_delete

    initialize_params {
      image = var.boot_disk_image
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }

  # Additional Disks
  dynamic "attached_disk" {
    for_each = google_compute_disk.additional
    content {
      source      = attached_disk.value.self_link
      device_name = attached_disk.value.name
    }
  }

  # Network Interface
  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    dynamic "access_config" {
      for_each = var.assign_external_ip ? [1] : []
      content {
        nat_ip       = var.external_ip_address
        network_tier = var.network_tier
      }
    }
  }

  # Metadata
  metadata = merge(
    var.metadata,
    var.startup_script != null ? { startup-script = var.startup_script } : {},
    length(var.ssh_keys) > 0 ? { ssh-keys = join("\n", var.ssh_keys) } : {}
  )

  # Service Account
  dynamic "service_account" {
    for_each = var.service_account_email != null ? [1] : []
    content {
      email  = var.service_account_email
      scopes = var.service_account_scopes
    }
  }

  # Scheduling
  scheduling {
    preemptible         = var.preemptible
    automatic_restart   = var.preemptible ? false : var.automatic_restart
    on_host_maintenance = var.preemptible ? "TERMINATE" : var.on_host_maintenance
  }

  labels = merge(
    var.labels,
    {
      name        = var.instance_name
      environment = var.environment
      managed_by  = "terraform"
    }
  )

  project = var.project_id
}

