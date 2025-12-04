#!/bin/bash

# Script to reconfigure Terraform backend
# Usage: ./reconfigure_backend.sh

set -e

echo "Reconfiguring Terraform backend..."
terraform init -reconfigure

echo "Backend reconfigured successfully!"
