#!/bin/bash

# Script to destroy Terraform resources for a specific environment
# Usage: ./destroy_per_env.sh <environment>

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

echo "Destroying Terraform resources for environment: $ENV"
echo "Using tfvars file: $TFVARS_FILE"

terraform destroy -var-file="$TFVARS_FILE"

echo "Successfully destroyed resources for environment: $ENV"
