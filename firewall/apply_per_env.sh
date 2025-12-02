#!/bin/bash

# Script to apply Terraform for different environments
# Usage: ./apply_per_env.sh <environment>
# Example: ./apply_per_env.sh prod

if [ -z "$1" ]; then
    echo "Error: Environment argument is required"
    echo "Usage: $0 <environment>"
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
