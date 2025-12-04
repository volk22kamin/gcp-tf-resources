#!/bin/bash

# Script to apply Terraform configuration for a specific environment
# Usage: ./apply_per_env.sh <environment>

set -e

if [ -z "$1" ]; then
  echo "Usage: $0 <environment>"
  echo "Example: $0 main"
  exit 1
fi

ENV=$1
TFVARS_FILE="environments/${ENV}.tfvars"

if [ ! -f "$TFVARS_FILE" ]; then
  echo "Error: Environment file $TFVARS_FILE not found!"
  exit 1
fi

echo "Applying Terraform configuration for environment: $ENV"
echo "Using tfvars file: $TFVARS_FILE"

terraform init
terraform plan -var-file="$TFVARS_FILE" -out="${ENV}.tfplan"
terraform apply "${ENV}.tfplan"
rm "${ENV}.tfplan"

echo "Successfully applied configuration for environment: $ENV"
