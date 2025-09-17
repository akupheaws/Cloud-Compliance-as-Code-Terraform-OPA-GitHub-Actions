package tfplan.tags_required

required_keys := {"Environment", "Owner", "CostCenter", "ComplianceClassification"}

deny[msg] {
  some i
  rc := input.resource_changes[i]
  rc.mode == "managed"
  rc.change.actions[_] == "create"  # check only creates/updates if you want: actions == ["create"] or has "update"
  rc.type == "aws_instance"
  after := rc.change.after
  tags := after.tags
  missing := required_keys - object.keys(tags)
  count(missing) > 0
  msg := sprintf("%s: missing required tags: %v", [rc.address, missing])
}

# Launch Templates: tags can be in .tags or tag_specifications[*].tags (resource_type="instance")
deny[msg] {
  rc := input.resource_changes[_]
  rc.type == "aws_launch_template"
  tags := merge_lt_tags(rc.change.after)
  missing := required_keys - object.keys(tags)
  count(missing) > 0
  msg := sprintf("%s: missing required tags: %v", [rc.address, missing])
}

merge_lt_tags(lt) = merged {
  base := lt.tags
  instags := instance_tags(lt.tag_specifications)
  merged := object.union(base, instags)
}

instance_tags(specs) = t {
  some i
  specs[i].resource_type == "instance"
  t := specs[i].tags
} else = {}
