terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "gke-state-273385931402" # To be configured
    prefix = "gke-cluster/terraform.tfstate"
  }
}

provider "google" {
  project = var.project_id
  region  = var.gcp_region
}
