# GCP VPC Terraform Module

A generic, reusable Terraform module for creating and managing Google Cloud VPC networks across multiple environments.

## 📁 Project Structure

```
vpc/
├── modules/
│   └── vpc/                    # Reusable VPC module
│       ├── main.tf            # VPC, subnets, router, NAT resources
│       ├── variables.tf       # Module input variables
│       └── outputs.tf         # Module outputs
├── environments/
│   └── main.tfvars.example   # Example environment configuration
├── main.tf                   # Root module (calls vpc module with for_each)
├── variables.tf              # Root variables
├── outputs.tf                # Aggregated outputs
├── provider.tf               # GCP provider configuration
├── apply_per_env.sh          # Helper script to apply
├── destroy_per_env.sh        # Helper script to destroy
└── reconfigure_backend.sh    # Helper script to reconfigure backend
```

## 🚀 Features

- **Generic Module Design**: Reusable VPC module with comprehensive configuration options
- **Multi-Network Support**: Create multiple VPC networks from a single configuration
- **Dynamic Subnet Creation**: Support for multiple subnets with secondary IP ranges (for GKE)
- **Cloud NAT**: Optional Cloud NAT for private instances
- **Private Google Access**: Enable private access to Google APIs
- **Flexible Configuration**: Support for:
  - Custom subnet CIDR ranges
  - Secondary IP ranges for GKE pods and services
  - Cloud Router and NAT configuration
  - NAT logging with configurable filters

## 📋 Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- GCP Project with Compute Engine API enabled
- Appropriate GCP credentials configured

## 🔧 Configuration

### 1. Create Environment File

Copy the example file and customize:

```bash
cp environments/main.tfvars.example environments/main.tfvars
```

Edit `environments/main.tfvars` and update:

- `project_id`: Your GCP project ID
- `vpc_networks`: Your VPC network configurations

### 2. Configure Backend

Edit `provider.tf` to set your GCS bucket for state storage:

```hcl
backend "gcs" {
  bucket = "your-terraform-state-bucket"
  prefix = "vpc/terraform.tfstate"
}
```

### 3. Authenticate with GCP

```bash
gcloud auth application-default login
gcloud config set project YOUR_PROJECT_ID
```

## 🎯 Usage

### Using Helper Scripts

```bash
# Make scripts executable
chmod +x *.sh

# Apply for main environment
./apply_per_env.sh main

# Destroy main environment
./destroy_per_env.sh main
```

### Manual Terraform Commands

```bash
# Initialize Terraform
terraform init

# Plan changes
terraform plan -var-file=environments/main.tfvars

# Apply changes
terraform apply -var-file=environments/main.tfvars

# Destroy resources
terraform destroy -var-file=environments/main.tfvars
```

## 📝 Example Configuration

```hcl
vpc_networks = {
  "k8s-vpc" = {
    region = "us-central1"
    subnets = [
      {
        name          = "k8s-subnet-a"
        ip_cidr_range = "10.0.1.0/24"
        secondary_ip_ranges = [
          {
            range_name    = "pods"
            ip_cidr_range = "10.1.0.0/16"
          },
          {
            range_name    = "services"
            ip_cidr_range = "10.2.0.0/16"
          }
        ]
      }
    ]
    enable_private_google_access = true
    enable_cloud_nat             = true
  }
}
```

## 🔍 Outputs

After applying, view outputs:

```bash
terraform output
terraform output network_self_links
terraform output subnet_self_links
```

## 🛡️ Best Practices

1. **Use Secondary IP Ranges**: Configure secondary ranges for GKE clusters
2. **Enable Private Google Access**: Allow private instances to access Google APIs
3. **Cloud NAT**: Use Cloud NAT for private instances that need internet access
4. **Consistent Naming**: Use environment prefixes for network names
5. **Label Everything**: Use consistent labeling for cost tracking

## 🔐 Security Considerations

- Never commit `.tfvars` files containing sensitive data
- Use GCS backend with encryption for state files
- Use firewall rules to restrict network access (see firewall module)
- Enable VPC Flow Logs for network monitoring

## 📄 Integration

This module works with:

- **firewall module**: For network security rules
- **gke-cluster module**: For Kubernetes clusters (use secondary IP ranges)
- **vm module**: For compute instances
