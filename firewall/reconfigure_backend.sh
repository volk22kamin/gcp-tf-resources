#!/bin/bash

# Script to reconfigure Terraform backend
# Usage: ./reconfigure_backend.sh <environment>
# Example: ./reconfigure_backend.sh prod

set -e

if [ -z "$1" ]; then
  echo "Error: Environment not specified"
  echo "Usage: $0 <environment>"
  echo "Example: $0 prod"
  exit 1
fi

ENV=$1
TFVARS_FILE="environments/${ENV}.tfvars"

if [ ! -f "$TFVARS_FILE" ]; then
  echo "Error: Environment file not found: $TFVARS_FILE"
  exit 1
fi

echo "Reconfiguring Terraform backend for environment: $ENV"
echo "Using tfvars file: $TFVARS_FILE"
echo ""

terraform init -reconfigure -var-file="$TFVARS_FILE"

echo "Backend reconfigured successfully for environment: $ENV"
