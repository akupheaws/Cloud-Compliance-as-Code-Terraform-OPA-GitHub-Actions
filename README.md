# Cloud Compliance as Code — Terraform + OPA (Conftest) + GitHub Actions

This project enforces **pre-deployment** compliance (Terraform plan gated by **OPA/Rego**) and **post-deployment** audits (live AWS EC2 checks) with GitHub Actions CI.

## What It Enforces (default)
- Required tags on VMs: `Environment`, `Owner`, `CostCenter`, `ComplianceClassification`
- Allowed values:
  - `Environment` ∈ {dev, qa, stage, prod}
  - `ComplianceClassification` ∈ {Public, Internal, PII, PCI}
  - `CostCenter` matches `^CC-\d{4}$`
  - `Owner` non-empty

## Quick start (local)
```bash
# 1) Tools: terraform, awscli, conftest, pre-commit (optional)
make tools-help

# 2) Initialize backend + providers
make init

# 3) Create a plan and export to JSON, then run OPA checks
make test     # (plan -> plan.json -> conftest test)

# 4) If compliant, apply
make apply

# 5) Optional: audit existing EC2 instances with OPA
export AWS_REGION=us-east-1
make audit-live
