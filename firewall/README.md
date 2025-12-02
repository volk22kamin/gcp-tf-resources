# GCP Firewall Terraform Module

A generic, reusable Terraform module for creating and managing Google Cloud Firewall rules across multiple VPCs.

## 📁 Project Structure

```
firewall/
├── modules/
│   └── firewall/               # Reusable firewall module
│       ├── main.tf            # Firewall rule resource
│       ├── variables.tf       # Module input variables
│       └── outputs.tf         # Module outputs
├── environments/
│   └── main.tfvars.example   # Example environment configuration
├── main.tf                   # Root module (calls firewall module with for_each)
├── variables.tf              # Root variables
├── outputs.tf                # Aggregated outputs
├── provider.tf               # GCP provider configuration
├── apply_per_env.sh          # Helper script to apply
├── destroy_per_env.sh        # Helper script to destroy
└── reconfigure_backend.sh    # Helper script to reconfigure backend
```

## 🚀 Features

- **Per-Rule VPC Assignment**: Each firewall rule can specify its own VPC network
- **Default Network Support**: Set a default network for all rules, override per rule as needed
- **Multi-Rule Support**: Create multiple firewall rules from a single configuration
- **Flexible Configuration**: Support for:
  - Allow and deny rules
  - Source/destination ranges
  - Source/target tags
  - Target service accounts
  - Priority and direction (INGRESS/EGRESS)
  - Logging configuration
  - Enable/disable rules

## 📋 Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- GCP Project with Compute Engine API enabled
- VPC network(s) created (see vpc module)
- Appropriate GCP credentials configured

## 🔧 Configuration

### 1. Create Environment File

Copy the example file and customize:

```bash
cp environments/main.tfvars.example environments/main.tfvars
```

### 2. Configure Backend

Edit `provider.tf` to set your GCS bucket for state storage:

```hcl
backend "gcs" {
  bucket = "your-terraform-state-bucket"
  prefix = "firewall/terraform.tfstate"
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

## 📝 Configuration Examples

### Example 1: Using Default Network

Set a default network and all rules will use it unless overridden:

```hcl
project_id = "my-project"
network    = "projects/my-project/global/networks/default-vpc"

firewall_rules = {
  "allow-ssh" = {
    # Uses default network
    allow_rules = [
      {
        protocol = "tcp"
        ports    = ["22"]
      }
    ]
    source_ranges = ["0.0.0.0/0"]
  }
}
```

### Example 2: Per-Rule Network Assignment

Each rule can specify its own VPC:

```hcl
project_id = "my-project"

firewall_rules = {
  "allow-http-vpc1" = {
    network = "projects/my-project/global/networks/vpc1"
    allow_rules = [
      {
        protocol = "tcp"
        ports    = ["80", "443"]
      }
    ]
    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["web-server"]
  }

  "allow-ssh-vpc2" = {
    network = "projects/my-project/global/networks/vpc2"
    allow_rules = [
      {
        protocol = "tcp"
        ports    = ["22"]
      }
    ]
    source_ranges = ["10.0.0.0/8"]
    target_tags   = ["ssh-enabled"]
  }
}
```

### Example 3: Mixed Approach

Combine default network with per-rule overrides:

```hcl
project_id = "my-project"
network    = "projects/my-project/global/networks/default-vpc"  # Default

firewall_rules = {
  "allow-internal-default" = {
    # Uses default network
    allow_rules = [
      {
        protocol = "all"
        ports    = []
      }
    ]
    source_ranges = ["10.0.0.0/8"]
  }

  "allow-gke-k8s-vpc" = {
    network = "projects/my-project/global/networks/k8s-vpc"  # Override
    allow_rules = [
      {
        protocol = "tcp"
        ports    = ["1-65535"]
      }
    ]
    source_tags = ["gke-node"]
    target_tags = ["gke-node"]
  }
}
```

### Example 4: GKE Firewall Rules

```hcl
firewall_rules = {
  "allow-gke-internal" = {
    network     = "projects/my-project/global/networks/k8s-vpc"
    description = "Allow internal GKE communication"
    direction   = "INGRESS"
    priority    = 1000
    allow_rules = [
      {
        protocol = "tcp"
        ports    = ["1-65535"]
      },
      {
        protocol = "udp"
        ports    = ["1-65535"]
      },
      {
        protocol = "icmp"
        ports    = []
      }
    ]
    source_tags = ["gke-node"]
    target_tags = ["gke-node"]
  }
}
```

## 🔍 Outputs

After applying, view outputs:

```bash
terraform output
terraform output firewall_rule_ids
```

## 🛡️ Best Practices

1. **Use Network Tags**: Prefer network tags over IP-based rules for flexibility
2. **Least Privilege**: Only allow necessary ports and protocols
3. **Document Rules**: Use descriptive names and descriptions
4. **Priority Management**: Use priorities to control rule precedence (lower = higher priority)
5. **Enable Logging**: Use `log_config` for important rules to track traffic
6. **Organize by VPC**: Group related rules together in your tfvars
7. **Use Deny Rules Carefully**: Deny rules can override allow rules based on priority

## 🔐 Security Considerations

- Avoid using `0.0.0.0/0` for source ranges in production
- Use service accounts for fine-grained access control
- Enable logging for security-critical rules
- Regularly audit firewall rules
- Use separate rules for different environments
- Consider using hierarchical firewall policies for organization-wide rules

## 📄 Integration

This module works with:

- **vpc module**: For VPC network infrastructure
- **gke-cluster module**: For GKE cluster firewall rules
- **vm module**: For VM instance firewall rules (via network tags)

## 🔧 Migration from Single VPC

If you're migrating from the old single-VPC configuration:

**Old way:**

```hcl
network = "projects/my-project/global/networks/my-vpc"
firewall_rules = {
  "allow-ssh" = { ... }
}
```

**New way (backward compatible):**

```hcl
# Option 1: Keep using default network (no changes needed)
network = "projects/my-project/global/networks/my-vpc"
firewall_rules = {
  "allow-ssh" = { ... }
}

# Option 2: Specify network per rule
firewall_rules = {
  "allow-ssh" = {
    network = "projects/my-project/global/networks/my-vpc"
    ...
  }
}
```

## 📚 Common Patterns

### Allow SSH from Specific IP

```hcl
"allow-ssh-office" = {
  network       = "projects/my-project/global/networks/my-vpc"
  description   = "Allow SSH from office"
  allow_rules   = [{ protocol = "tcp", ports = ["22"] }]
  source_ranges = ["203.0.113.0/24"]
  target_tags   = ["ssh-enabled"]
}
```

### Allow Internal Traffic

```hcl
"allow-internal" = {
  network       = "projects/my-project/global/networks/my-vpc"
  description   = "Allow all internal traffic"
  allow_rules   = [{ protocol = "all", ports = [] }]
  source_ranges = ["10.0.0.0/8"]
}
```

### Deny All Egress (High Priority)

```hcl
"deny-all-egress" = {
  network     = "projects/my-project/global/networks/my-vpc"
  description = "Deny all egress"
  direction   = "EGRESS"
  priority    = 100
  deny_rules  = [{ protocol = "all", ports = [] }]
}
```
