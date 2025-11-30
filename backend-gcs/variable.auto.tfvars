project_id = "training-472512"
region     = "us-east1"

buckets = {
  vm = {
    bucket_name_prefix = "vm-state"
    environment        = "prod"
    location           = "us-east1"
  }
}
