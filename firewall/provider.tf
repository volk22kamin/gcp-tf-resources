terraform {
  required_version = ">= 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "fw-state-1009189179293"
    prefix = "firewall/terraform.tfstate"
  }
}

provider "google" {
  project = var.project_id
}
