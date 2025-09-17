
---

## 🧰 `Makefile`

```make
SHELL := /usr/bin/env bash
TF_DIR := terraform
PLAN_OUT := plan.out
PLAN_JSON := plan.json

.PHONY: tools-help init validate plan plan-json test apply destroy audit-live

tools-help:
	@echo "Required tools: terraform >=1.5, awscli, conftest, (optional) pre-commit"

init:
	cd $(TF_DIR) && terraform init -upgrade

validate:
	cd $(TF_DIR) && terraform validate

plan:
	cd $(TF_DIR) && terraform plan -out $(PLAN_OUT)

plan-json: plan
	cd $(TF_DIR) && terraform show -json $(PLAN_OUT) > $(PLAN_JSON)
	@echo "Wrote $(TF_DIR)/$(PLAN_JSON)"

test: plan-json
	conftest test $(TF_DIR)/$(PLAN_JSON) --policy policies/tfplan

apply:
	cd $(TF_DIR) && terraform apply $(PLAN_OUT)

destroy:
	cd $(TF_DIR) && terraform destroy -auto-approve

audit-live:
	./scripts/audit_live_aws.sh
