#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."/terraform

terraform init -upgrade
terraform plan -out plan.out
terraform show -json plan.out > plan.json
echo "Wrote terraform/plan.json"
