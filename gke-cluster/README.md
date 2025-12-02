# GCP GKE Cluster Terraform Module

A generic, reusable Terraform module for creating and managing Google Kubernetes Engine (GKE) clusters across multiple environments.

## 📁 Project Structure

```
gke-cluster/
├── modules/
│   └── gke-cluster/            # Reusable GKE cluster module
│       ├── main.tf            # Cluster and node pool resources
│       ├── variables.tf       # Module input variables
│       └── outputs.tf         # Module outputs
├── environments/
│   └── main.tfvars.example   # Example environment configuration
├── main.tf                   # Root module (calls gke-cluster module with for_each)
├── variables.tf              # Root variables
├── outputs.tf                # Aggregated outputs
├── provider.tf               # GCP provider configuration
├── apply_per_env.sh          # Helper script to apply
├── destroy_per_env.sh        # Helper script to destroy
└── reconfigure_backend.sh    # Helper script to reconfigure backend
```

## 🚀 Features

- **Generic Module Design**: Reusable GKE cluster module with comprehensive configuration options
- **Multi-Cluster Support**: Create multiple GKE clusters from a single configuration
- **Node Pool Management**: Flexible node pool configuration with autoscaling
- **VPC-Native Clusters**: Support for secondary IP ranges (alias IPs)
- **Private Clusters**: Optional private cluster configuration
- **Flexible Configuration**: Support for:
  - Multiple node pools per cluster
  - Custom machine types and disk configurations
  - Preemptible nodes for cost optimization
  - Auto-upgrade and auto-repair
  - Network tags and labels
  - Master authorized networks
  - Release channels (RAPID, REGULAR, STABLE)

## 📋 Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- GCP Project with:
  - Kubernetes Engine API enabled
  - Compute Engine API enabled
- VPC network with subnets (see vpc module)
- Appropriate GCP credentials configured

## 🔧 Configuration

### 1. Create VPC First

Before creating a GKE cluster, ensure you have a VPC network with subnets configured with secondary IP ranges:

```bash
cd ../vpc
# Configure and apply VPC module first
```

### 2. Create Environment File

Copy the example file and customize:

```bash
cp environments/main.tfvars.example environments/main.tfvars
```

Edit `environments/main.tfvars` and update:

- `project_id`: Your GCP project ID
- `network` and `subnetwork`: References to your VPC (from vpc module outputs)
- `ip_allocation_policy`: Secondary range names for pods and services
- `node_pools`: Your node pool configurations

### 3. Configure Backend

Edit `provider.tf` to set your GCS bucket for state storage:

```hcl
backend "gcs" {
  bucket = "your-terraform-state-bucket"
  prefix = "gke-cluster/terraform.tfstate"
}
```

### 4. Authenticate with GCP

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
gke_clusters = {
  "primary-cluster" = {
    location   = "us-central1"
    network    = "projects/my-project/global/networks/main-k8s-vpc"
    subnetwork = "projects/my-project/regions/us-central1/subnetworks/k8s-subnet-a"

    ip_allocation_policy = {
      cluster_secondary_range_name  = "pods"
      services_secondary_range_name = "services"
    }

    node_pools = {
      "default-pool" = {
        machine_type = "e2-medium"
        min_count    = 1
        max_count    = 3
        disk_size_gb = 50
      }
    }
  }
}
```

## 🔍 Outputs

After applying, view outputs:

```bash
terraform output
terraform output cluster_endpoints
```

## 🔗 Connecting to Cluster

After cluster creation, configure kubectl:

```bash
gcloud container clusters get-credentials CLUSTER_NAME --region REGION --project PROJECT_ID
```

## 🛡️ Best Practices

1. **Use VPC-Native Clusters**: Always configure `ip_allocation_policy` with secondary ranges
2. **Enable Auto-Upgrade**: Keep clusters updated with `default_auto_upgrade = true`
3. **Enable Auto-Repair**: Automatically repair unhealthy nodes
4. **Use Release Channels**: Subscribe to REGULAR or STABLE release channels
5. **Node Pool Strategy**: Use multiple node pools for different workload types
6. **Deletion Protection**: Enable for production clusters
7. **Private Clusters**: Consider private clusters for enhanced security
8. **Resource Labels**: Use labels for cost tracking and organization

## 🔐 Security Considerations

- Use private clusters for production workloads
- Configure master authorized networks to restrict API access
- Use workload identity for pod authentication
- Enable network policies for pod-to-pod security
- Regularly update cluster and node versions
- Use separate node pools for sensitive workloads

## 📄 Integration

This module works with:

- **vpc module**: For network infrastructure (required)
- **firewall module**: For additional network security rules
- **vm module**: For bastion hosts or other compute instances

## 🔧 Troubleshooting

### Cluster Creation Fails

- Ensure VPC and subnets exist
- Verify secondary IP ranges are configured
- Check API quotas in your project

### Node Pool Issues

- Verify machine type availability in your region
- Check disk size meets minimum requirements
- Ensure service account has proper permissions
