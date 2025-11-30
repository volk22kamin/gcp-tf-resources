terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "vm-state-1009189179293"
    prefix = "vm/terraform.tfstate"
  }
}

provider "google" {
  project = var.project_id
  region  = var.gcp_region
}
