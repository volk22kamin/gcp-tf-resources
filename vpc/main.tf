module "vpc" {
  for_each = var.vpc_networks
  source   = "./modules/vpc"

  project_id   = var.project_id
  network_name = "${var.environment}-${each.key}"
  region       = each.value.region != null ? each.value.region : var.gcp_region

  subnets                      = each.value.subnets
  enable_private_google_access = each.value.enable_private_google_access
  enable_cloud_nat             = each.value.enable_cloud_nat
  nat_ip_allocate_option       = each.value.nat_ip_allocate_option
  enable_nat_logging           = each.value.enable_nat_logging
  nat_log_filter               = each.value.nat_log_filter
}

resource "google_project_service" "apis" {
  for_each = toset(local.required_apis)
  project  = var.project_id
  service  = each.key

  # Keep the API enabled even when you destroy the stack
  disable_on_destroy = false
}
