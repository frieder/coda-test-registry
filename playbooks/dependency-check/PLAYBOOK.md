---
name: dependency-check
description: Lists outdated dependencies and known vulnerabilities of the project, read-only, with a recommendation per finding - for a weekly schedule or before a release.
version: "1.0"
inputs:
  ecosystems: {type: multi-select, options: [npm, maven, gradle, go, pip, terraform], label: "Ecosystems (empty = all the project uses)"}
  min_severity: {type: dropdown, options: [low, moderate, high, critical], default: high, label: "Report vulnerabilities from"}
  include_major: {type: yes/no, default: no, label: "Include major-version upgrades"}
  max_items: {type: number, min: 5, max: 50, default: 15, label: "At most this many findings"}
done_when:
  - Every finding names the package, the current and the proposed version, and why.
  - No file of the project was changed.
---

Check the project's dependencies. **Read only: don't change, install or upgrade anything, don't commit.**

Ecosystems to check: {ecosystems} (if empty, every ecosystem the project uses - look for package.json, pom.xml,
build.gradle, go.mod, requirements*.txt / pyproject.toml, *.tf).

1. Outdated dependencies, with the tool of each ecosystem: `npm outdated`, `mvn versions:display-dependency-updates`,
   `gradle dependencyUpdates` (only if the plugin is set up), `go list -m -u all`, `pip list --outdated` (inside the
   project's virtual environment), `terraform init -upgrade=false` then `terraform providers`. Include major-version
   upgrades: {include_major}.
2. Known vulnerabilities from severity {min_severity} upwards: `npm audit`, `govulncheck ./...`, `pip-audit`,
   `mvn org.owasp:dependency-check-maven:check` only if the project already uses it. A tool that isn't installed:
   say so, don't install it.
3. Report at most {max_items} findings, most urgent first, as a table: package · current · proposed · why
   (vulnerability id or what the upgrade brings) · risk of the upgrade (breaking changes you found in the changelog).

End with one line: what you would upgrade first, and what you didn't check.
