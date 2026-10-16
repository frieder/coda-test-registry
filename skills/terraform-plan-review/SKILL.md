---
name: terraform-plan-review
description: Check a Terraform change before anyone applies it - format, validate, plan into a file, and summarise what the plan creates, changes, replaces and destroys. Use when changing or reviewing Terraform code (*.tf), or when asked what a Terraform change will do.
---

# Terraform plan review

Never apply. This skill only reads: it tells the team what an apply would do.

## 1. Check the code

```
terraform fmt -check -recursive
terraform init -backend=false -input=false   # only if .terraform/ is missing
terraform validate
```

Fix formatting with `terraform fmt -recursive` only if the files are part of
your task; otherwise report them.

## 2. Plan into a file

```
terraform plan -input=false -lock=false -out=plan.out
```

- Plan only against the environment you were told to use. If the backend or
  workspace is unclear, stop and ask; do not switch workspaces yourself.
- A plan that needs credentials you don't have: report it, don't hunt for them.

## 3. Summarise the plan

Run the helper (it needs `jq`):

```
scripts/plan-summary.sh plan.out
```

It prints one line per resource that changes and the totals:

```
replace  aws_instance.web          (forces replacement: ami)
delete   aws_s3_bucket.old_logs
create   aws_iam_role.ci
totals: 1 to create, 0 to change, 1 to replace, 1 to delete
```

## 4. Report

- Every **delete** and **replace** on its own line, with why (the attribute
  that forces it). These are what reviewers must look at.
- Changes to IAM, security groups, public access and encryption settings,
  even small ones.
- What you did not check (other workspaces, modules from a registry you did
  not read).

Delete `plan.out` when you are done; never commit it.
