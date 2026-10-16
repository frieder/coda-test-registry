---
name: security-review
description: Run a focused security pass on a change or code area, checking trust boundaries, injection, auth, secrets, deserialization, path traversal, SSRF and dependency risk, and report findings with exploit sketches in a fixed finding format. Use when a change handles external input, credentials, files, network requests or permissions, or when a security review is requested.
---

# Security Review

Look for ways an attacker can make the code do something it should not.
Report what you can show, and be honest about what you only suspect.

## 1. Scope and pin

- Name the scope: a commit range (`base..head` as SHAs) or a set of paths.
- Review only that scope, at that revision. Do not edit the code.

## 2. Map trust boundaries

Before reading line by line, list where untrusted data enters and where it
reaches something sensitive:

- Sources: HTTP params, headers, bodies, CLI args, env vars, files, uploads,
  queue messages, webhooks, LLM or agent output, database content written
  by users.
- Sinks: shell, SQL, templates/HTML, file system paths, outbound HTTP,
  deserializers, eval, logs, auth decisions.

Follow each source to each sink and check validation along the way.

## 3. Checklist

- **Injection**: command (`exec`, `sh -c`, string-built args), SQL (string
  concatenation instead of parameters), template/HTML (XSS), LDAP, header
  injection, log injection.
- **Authn/Authz**: missing auth on new endpoints, checks done client-side
  only, IDOR (object IDs not scoped to the caller), privilege escalation,
  session/token handling, CSRF on state-changing requests.
- **Secrets**: keys, tokens or passwords in code, config, tests, logs, error
  messages or commits; overly broad credentials.
- **Unsafe deserialization**: untrusted input into pickle, Java
  serialization, YAML with object tags, gob into interfaces, `eval`.
- **Path traversal**: user input in file paths without cleaning and
  containment check (`..`, absolute paths, symlinks, zip slip).
- **SSRF**: user-controlled URLs fetched server-side; check for internal
  addresses, metadata endpoints (169.254.169.254), redirects, DNS rebinding.
- **Dependencies**: new or bumped packages, unpinned versions, known CVEs,
  abandoned or typo-squatted names; run the ecosystem audit tool if
  available (`govulncheck`, `npm audit`, `pip-audit`).
- **Other**: weak crypto or randomness, TLS verification disabled, overly
  permissive file modes or CORS, resource exhaustion (unbounded reads,
  regex DoS), race conditions around checks (TOCTOU).

## 4. Report

One entry per finding, in this format:

```
severity: blocking   evidence: confirmed
where: internal/server/files.go:57
condition: the name query param is joined to the workspace root without a
  containment check (path traversal).
fix: filepath.Clean, then require strings.HasPrefix(abs, root+sep);
  reject absolute paths and symlinks escaping root.
proof: GET /api/files?name=../../../../etc/hostname returns the host's
  file (reproduced against a local server).
```

- `blocking` for anything exploitable or a violated security guideline;
  `advice` for hardening.
- `confirmed` (exploited or reproduced, with the steps), `criterion` (cites
  the guideline or requirement it violates) or `suspected` (plausible, not
  demonstrated; say what is missing). Only confirmed and criterion block.
- The exploit sketch goes into `proof`: concrete input and effect, not
  "could be exploited".

End with: scope reviewed, tools run, what was not checked, and the verdict
(`approve` or `changes`).

## Do not

- Run exploits against production or third-party systems.
- Include real secrets in the report; reference their location instead.
- Report generic best practices without a concrete path in this code.
- Edit the code under review.
