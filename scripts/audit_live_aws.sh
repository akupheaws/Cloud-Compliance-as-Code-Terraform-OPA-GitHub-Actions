#!/usr/bin/env bash
set -euo pipefail
OUT="instances.json"
REGION="${AWS_REGION:-us-east-1}"
aws ec2 describe-instances --region "$REGION" > "$OUT"
echo "Wrote $OUT"
conftest test "$OUT" --policy policies/live
