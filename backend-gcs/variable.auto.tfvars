project_id = "terraform-480008"
region     = "us-east1"

buckets = {
  vm = {
    bucket_name_prefix = "vm-state"
    environment        = "prod"
    location           = "us-east1"
  }
  fw = {
    bucket_name_prefix = "fw-state"
    environment        = "prod"
    location           = "us-east1"
  }
  gke = {
    bucket_name_prefix = "gke-state"
    environment        = "prod"
    location           = "us-east1"
  }
  vpc = {
    bucket_name_prefix = "vpc-state"
    environment        = "prod"
    location           = "us-east1"
  }
}
