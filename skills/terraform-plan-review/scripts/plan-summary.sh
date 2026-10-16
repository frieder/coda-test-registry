#!/usr/bin/env bash
# Summarises a saved Terraform plan: one line per changed resource, then the totals. Reads only.
# Usage: scripts/plan-summary.sh plan.out
set -euo pipefail
plan="${1:-plan.out}"
if [ ! -f "$plan" ]; then
  echo "no plan file $plan - run: terraform plan -out=$plan" >&2
  exit 2
fi
command -v jq >/dev/null || { echo "jq is needed" >&2; exit 2; }
terraform show -json "$plan" | jq -r '
  def kind: if (.change.actions | index("delete")) and (.change.actions | index("create")) then "replace"
            elif .change.actions == ["delete"] then "delete"
            elif .change.actions == ["create"] then "create"
            elif .change.actions == ["update"] then "update"
            else empty end;
  [.resource_changes[]? | {k: kind, a: .address, r: ((.change.replace_paths // []) | map(map(tostring) | join(".")) | join(", "))}
   | select(.k != null)] as $c
  | ($c | sort_by({"replace": 0, "delete": 1, "update": 2, "create": 3}[.k])[] | "\(.k)\t\(.a)\(if .r != "" then "\t(forces replacement: \(.r))" else "" end)"),
    "totals: \($c | map(select(.k == "create")) | length) to create, \($c | map(select(.k == "update")) | length) to change, \($c | map(select(.k == "replace")) | length) to replace, \($c | map(select(.k == "delete")) | length) to delete"'
