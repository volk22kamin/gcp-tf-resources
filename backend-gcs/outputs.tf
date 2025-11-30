output "bucket_names" {
  description = "Map of GCS bucket names keyed by the provided identifier."
  value       = { for key, bucket in google_storage_bucket.tf_backend : key => bucket.name }
}

output "bucket_urls" {
  description = "Map of GCS bucket URLs keyed by the provided identifier."
  value       = { for key, bucket in google_storage_bucket.tf_backend : key => bucket.url }
}
