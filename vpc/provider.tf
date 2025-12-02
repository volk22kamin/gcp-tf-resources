terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "vpc-state-273385931402"
    prefix = "vpc/terraform.tfstate"
  }
}

provider "google" {
  project = var.project_id
  region  = var.gcp_region
}
