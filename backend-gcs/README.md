# GCS Backend Module

This module creates Google Cloud Storage (GCS) buckets for storing Terraform state files.

## Features

- **Versioning**: Automatically enabled on all buckets to track state file history
- **Uniform Bucket-Level Access**: Enforces consistent access control
- **Public Access Prevention**: Blocks public access to state files
- **Unique Naming**: Appends project number to bucket names for global uniqueness
- **Flexible Configuration**: Support for multiple buckets with custom labels and locations

## Usage

1. Update `variable.auto.tfvars` with your GCP project ID and desired buckets
2. Initialize Terraform: `terraform init`
3. Review the plan: `terraform plan`
4. Apply the configuration: `terraform apply`

## Important Notes

- This module stores its own state **locally** (not in GCS)
- The created buckets are intended for storing state of other Terraform modules
- Bucket names must be globally unique across all GCP projects

## Example Configuration

```hcl
project_id = "my-gcp-project"

buckets = {
  vm = {
    bucket_name_prefix = "vm-state"
    environment        = "prod"
    location           = "us-central1"  # Optional, defaults to var.region
    labels = {                          # Optional
      team = "devops"
    }
  }
  networking = {
    bucket_name_prefix = "network-state"
    environment        = "prod"
  }
}
```

## Outputs

- `bucket_names`: Map of bucket names for use in backend configurations
- `bucket_urls`: Map of bucket URLs

## Using the Created Buckets as Backends

After creating the buckets, configure your other modules to use them:

```hcl
terraform {
  backend "gcs" {
    bucket = "vm-state-123456789012"  # Use the output bucket name
    prefix = "terraform/state"
  }
}
```
