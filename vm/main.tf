module "vm" {
  for_each = var.vm_instances
  source   = "./modules/vm"

  instance_name = "${var.environment}-${each.key}"
  zone          = each.value.zone != null ? each.value.zone : var.gcp_zone
  project_id    = var.project_id

  machine_type     = each.value.machine_type
  description      = each.value.description
  boot_disk_image  = each.value.boot_disk_image
  boot_disk_size   = each.value.boot_disk_size
  boot_disk_type   = each.value.boot_disk_type
  additional_disks = each.value.additional_disks

  network            = each.value.network
  subnetwork         = each.value.subnetwork
  assign_external_ip = each.value.assign_external_ip
  network_tags       = each.value.network_tags

  metadata       = each.value.metadata
  startup_script = each.value.startup_script

  service_account_email  = each.value.service_account_email
  service_account_scopes = each.value.service_account_scopes

  preemptible         = each.value.preemptible
  deletion_protection = each.value.deletion_protection

  environment = var.environment
  labels = merge(
    var.common_labels,
    each.value.labels
  )
}
