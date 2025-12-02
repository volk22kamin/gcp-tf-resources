resource "google_compute_network" "vpc" {
  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "subnets" {
  for_each      = { for subnet in var.subnets : subnet.name => subnet }
  project       = var.project_id
  name          = each.value.name
  ip_cidr_range = each.value.ip_cidr_range
  region        = var.region
  network       = google_compute_network.vpc.self_link

  private_ip_google_access = var.enable_private_google_access

  dynamic "secondary_ip_range" {
    for_each = lookup(each.value, "secondary_ip_ranges", [])
    content {
      range_name    = secondary_ip_range.value.range_name
      ip_cidr_range = secondary_ip_range.value.ip_cidr_range
    }
  }
}

resource "google_compute_router" "router" {
  count   = var.enable_cloud_nat ? 1 : 0
  project = var.project_id
  name    = "${var.network_name}-router"
  network = google_compute_network.vpc.self_link
  region  = var.region
}

resource "google_compute_router_nat" "nat" {
  count                              = var.enable_cloud_nat ? 1 : 0
  project                            = var.project_id
  name                               = "${var.network_name}-nat"
  router                             = google_compute_router.router[0].name
  region                             = var.region
  source_subnetwork_ip_ranges_to_nat = var.nat_ip_allocate_option

  nat_ip_allocate_option = var.nat_ip_allocate_option

  dynamic "log_config" {
    for_each = var.enable_nat_logging ? [1] : []
    content {
      enable = true
      filter = var.nat_log_filter
    }
  }
}
