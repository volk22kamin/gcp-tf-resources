# GCP VM Terraform Module

A generic, reusable Terraform module for creating and managing Google Compute Engine VM instances across multiple environments.

## 📁 Project Structure

```
vm/
├── modules/
│   └── vm/                    # Reusable VM module
│       ├── main.tf           # VM instance and disk resources
│       ├── variables.tf      # Module input variables
│       ├── outputs.tf        # Module outputs
│       └── README.md         # Module documentation
├── environments/
│   ├── dev.tfvars           # Development environment
│   ├── staging.tfvars       # Staging environment
│   └── prod.tfvars          # Production environment
├── main.tf                  # Root module (calls vm module with for_each)
├── variables.tf             # Root variables
├── outputs.tf               # Aggregated outputs
├── provider.tf              # GCP provider configuration
├── apply_per_env.sh         # Helper script to apply
├── destroy_per_env.sh       # Helper script to destroy
├── reconfigure_backend.sh   # Helper script to reconfigure backend
└── .gitignore              # Git ignore patterns
```

## 🚀 Features

- **Generic Module Design**: Reusable VM module with comprehensive configuration options
- **Multi-Environment Support**: Separate tfvars files for dev, staging, and prod
- **Dynamic Instance Creation**: Use `for_each` to create multiple VMs from a map
- **Flexible Configuration**: Support for:
  - Various machine types and zones
  - Custom boot disks and additional persistent disks
  - Network configuration with tags and external IPs
  - Metadata and startup scripts
  - Service accounts with custom scopes
  - Preemptible instances
  - Deletion protection
  - Labels and tags

## 📋 Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- GCP Project with Compute Engine API enabled
- Appropriate GCP credentials configured

## 🔧 Configuration

### 1. Update Project ID

Edit the environment tfvars files and replace `your-gcp-project-id` with your actual GCP project ID:

```bash
# environments/dev.tfvars
project_id = "your-actual-project-id"
```

### 2. Configure Backend (Optional)

Edit `provider.tf` to configure remote state storage in GCS:

```hcl
backend "gcs" {
  bucket = "your-terraform-state-bucket"
  prefix = "vm/terraform.tfstate"
}
```

### 3. Authenticate with GCP

```bash
gcloud auth application-default login
gcloud config set project YOUR_PROJECT_ID
```

## 🎯 Usage

### Using Helper Scripts

The easiest way to manage your infrastructure:

```bash
# Make scripts executable
chmod +x *.sh

# Apply for development environment
./apply_per_env.sh dev

# Apply for staging environment
./apply_per_env.sh staging

# Apply for production environment
./apply_per_env.sh prod

# Destroy development environment
./destroy_per_env.sh dev
```

### Manual Terraform Commands

```bash
# Initialize Terraform
terraform init

# Plan changes for dev environment
terraform plan -var-file=environments/dev.tfvars

# Apply changes for dev environment
terraform apply -var-file=environments/dev.tfvars

# Destroy resources
terraform destroy -var-file=environments/dev.tfvars
```

## 📝 Adding New VMs

To add a new VM instance, edit the appropriate environment tfvars file:

```hcl
vm_instances = {
  "my-new-vm" = {
    machine_type    = "e2-medium"
    description     = "My new VM instance"
    boot_disk_image = "debian-cloud/debian-11"
    boot_disk_size  = 20
    network_tags    = ["http-server", "ssh"]
    labels = {
      role = "custom"
    }
  }
}
```

## 🔍 Outputs

After applying, you can view outputs:

```bash
# View all outputs
terraform output

# View specific output
terraform output internal_ips
terraform output external_ips
```

## 📚 Module Documentation

For detailed module documentation, see [modules/vm/README.md](modules/vm/README.md).

## 🛡️ Best Practices

1. **Use Deletion Protection**: Enable `deletion_protection = true` for production VMs
2. **Label Everything**: Use consistent labeling for cost tracking and organization
3. **Network Tags**: Use network tags for firewall rules instead of IP-based rules
4. **Startup Scripts**: Use startup scripts for initial configuration
5. **Service Accounts**: Use dedicated service accounts with minimal required scopes
6. **Disk Management**: Set `auto_delete = false` for important data disks

## 🔐 Security Considerations

- Never commit `.tfvars` files containing sensitive data
- Use GCS backend with encryption for state files
- Enable deletion protection for production instances
- Use network tags and firewall rules to restrict access
- Regularly review and rotate service account keys

## 📄 License

This module is provided as-is for educational and production use.

## 🤝 Contributing

Feel free to submit issues and enhancement requests!
