#!/bin/bash

# Script to reconfigure Terraform backend for different environments
# Usage: ./reconfigre_backend.sh <environment>
# Example: ./reconfigre_backend.sh dev

if [ -z "$1" ]; then
    echo "Error: Environment argument is required"
    echo "Usage: $0 <environment>"
    echo "Example: $0 dev"
    echo "Example: $0 prod"
    exit 1
fi

ENV=$1

echo "Applying Terraform for environment: $ENV"
terraform apply --auto-approve -var-file=environments/$ENV.tfvars

if [ $? -eq 0 ]; then
    echo "Successfully applied Terraform for $ENV environment"
else
    echo "Error: Failed to apply Terraform for $ENV environment"
    exit 1
fi
