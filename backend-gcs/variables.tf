variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "Default region for resources"
  type        = string
  default     = "us-central1"
}

variable "buckets" {
  description = "Map of GCS buckets to create, keyed by a friendly name."
  type = map(object({
    bucket_name_prefix = string
    environment        = string
    location           = optional(string)
    labels             = optional(map(string), {})
  }))
}
