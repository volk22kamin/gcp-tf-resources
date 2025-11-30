provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_storage_bucket" "tf_backend" {
  for_each      = var.buckets
  name          = "${each.value.bucket_name_prefix}-${local.project_number}"
  location      = try(each.value.location, var.region)
  force_destroy = true

  versioning {
    enabled = true
  }

  uniform_bucket_level_access = true
  public_access_prevention    = "enforced"

  labels = merge({
    name        = "terraform-state-bucket"
    environment = each.value.environment
  }, try(each.value.labels, {}))
}


