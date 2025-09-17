package live.aws_ec2_tags

valid_envs := {"dev", "qa", "stage", "prod"}
valid_classes := {"Public", "Internal", "PII", "PCI"}
costcenter_re := `^CC-\d{4}$`
required := {"Environment", "Owner", "CostCenter", "ComplianceClassification"}

# Input: output from `aws ec2 describe-instances`
deny[msg] {
  inst := instances[_]
  tags := to_map(inst.Tags)
  missing := required - object.keys(tags)
  count(missing) > 0
  msg := sprintf("%s: missing required tags: %v", [inst.InstanceId, missing])
}

deny[msg] {
  inst := instances[_]
  tags := to_map(inst.Tags)
  not valid_env(tags["Environment"])
  msg := sprintf("%s: invalid Environment: %v", [inst.InstanceId, tags["Environment"]])
}

deny[msg] {
  inst := instances[_]
  tags := to_map(inst.Tags)
  not valid_owner(tags["Owner"])
  msg := sprintf("%s: invalid Owner (empty)", [inst.InstanceId])
}

deny[msg] {
  inst := instances[_]
  tags := to_map(inst.Tags)
  not valid_costcenter(tags["CostCenter"])
  msg := sprintf("%s: invalid CostCenter (expect CC-\\d{4}): %v", [inst.InstanceId, tags["CostCenter"]])
}

deny[msg] {
  inst := instances[_]
  tags := to_map(inst.Tags)
  not valid_class(tags["ComplianceClassification"])
  msg := sprintf("%s: invalid ComplianceClassification: %v", [inst.InstanceId, tags["ComplianceClassification"]])
}

instances[i] {
  res := input.Reservations[_]
  i := res.Instances[_]
}

to_map(arr) = {t.Key: t.Value | t := arr[_]}

valid_env(v) { v != null; valid_envs[v] }
valid_owner(v) { v != null; trim(v) != "" }
valid_costcenter(v) { v != null; re_match(costcenter_re, v) }
valid_class(v) { v != null; valid_classes[v] }
trim(s) = t { t := trim_space(s) }
