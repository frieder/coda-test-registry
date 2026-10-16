# Coda test registry (alpha.15)

A Git repository's content for testing Coda's registries: at least two of every kind a registry can hold, plus
items made to be flagged or rejected so you can see each outcome of the import. Copy this folder into a Git
repository (keep the scripts' executable bits), commit, push it to your Git host, and add its URL in «Library» →
«Registries» (a registry is always a Git repository).

Every item is a folder. Its main file has YAML front matter (`name:`, `description:`) and Markdown; policies,
workflows and agent definitions add a JSON file with the configuration. Items whose name starts with `zz-` are test
items: flagged, invalid or unusable on purpose.

## What the import should show

Skills, hooks, playbooks and MCP servers go through the **import check**. The icons below are what **«Only Coda's
scan»** gives, and they are always the same. Check agents may add their own concerns on top.
✓ nothing flagged · **!** to look at (a medium scan finding; ticked) · **✕** a real finding (waits for you,
unticked; imported anyway, the item carries **caution**).

Policies, workflows and agent definitions are data and get no import check. The dialog shows a review instead:
✓ nothing to warn about · **!** warnings (badge «N looser», for definitions «N missing here») · **invalid** (red
badge with the error; it can't be imported).

### Skills (`skills/`)

| Item | What it does | Import |
|---|---|---|
| `commit-hygiene` | Small, focused commits; check the staged diff; no secrets or generated files; never rewrite shared history | ✓ |
| `explore-before-asking` | Gather evidence from the repo first, then ask one question at a time with a recommendation | ✓ |
| `security-review` | Trust boundaries, injection, auth, secrets, path traversal, SSRF, dependencies; findings with exploit sketches | ✓ |
| `test-first-bugfix` | A failing test first, then root cause and the smallest fix | ✓ |
| `terraform-plan-review` | fmt, validate, plan to a file, and a summary of creates/changes/replaces/deletes (`scripts/plan-summary.sh`, needs jq) | ✓ (scripts) |

The first four were Coda's built-in skills until alpha.14. They are now ordinary skills without the Coda-specific
lines (those moved into `coda-hand-in`, `coda-reproduce` and `coda-judge`).

### Hooks (`hooks/`)

| Item | Event | What it does | Import |
|---|---|---|---|
| `format-check` | `turn_ended` (workers, success) | gofmt / Prettier / Black / terraform fmt on the changed files; **fails** with the list when one needs formatting; `.coda/format-check.log` | ✓ |
| `todo-reminder` | `turn_ended`, `task_done` (success) | Lists TODO/FIXME/XXX/HACK lines just added in `.coda/todo-reminder.log`; always exits 0 | ✓ |
| `notify-chat` | `question`, `permission` | Posts "an agent waits for you" to a Slack/Teams webhook from `CHAT_WEBHOOK_URL`; does nothing without it | **!** "sends data to a URL" (`scripts/notify.sh` line 16) |
| `zz-should-be-flagged-download-and-run` | `agent_joined` | Test item, does nothing (exits before the lines below) | **✕** 2 high: "downloads a script and runs it at once" (`setup.sh` line 7) and "reads SSH keys or stored credentials" (line 8) |

The scripts are bash (Git Bash on Windows). To see the hooks run, add them to a light project and let an agent
change a file.

### Playbooks (`playbooks/`)

| Item | What it does | Inputs | Import |
|---|---|---|---|
| `dependency-check` | Outdated dependencies and known vulnerabilities, read-only, one recommendation each | multi-select, dropdown, yes/no, number | ✓ |
| `release-prep` | Release notes from Git history, version bump, checks; stops before tag and push | text (required), date `today-14d`, Git branch, file, radio | ✓ |

A playbook's body is its prompt, so these folders have no separate readme; the description says what each one does.

### MCP servers (`mcp/`, official `server.json` format; «Library» → «MCP» → «＋▾» → «From a registry…»)

| Item | What Coda makes of it | Import |
|---|---|---|
| `filesystem` | **filesystem**, a command: `npx -y @modelcontextprotocol/server-filesystem .` | ✓ |
| `fetch` | **fetch**, a command: `uvx mcp-server-fetch` | ✓ |
| `github` | **github-mcp-server**, a URL server `https://api.githubcopilot.com/mcp/`; header `Authorization` = `Bearer {secret}` from the secret **GITHUB_MCP_TOKEN** | ✓ |
| `zz-unsupported-sse` | Test item: SSE-only remote | listed with "nothing Coda can run yet: remote type sse (Coda takes streamable HTTP)"; can't be imported |

To use `github-mcp-server`, add the secret `GITHUB_MCP_TOKEN` (a GitHub token) with the host
`api.githubcopilot.com`. Without it, Coda leaves the server out at launch and says why.

### Policies (`policies/`: POLICY.md + policy.json)

| Item | What it does | Import |
|---|---|---|
| `strict-no-network` | «Strict - no network»: 17 events denied (web, uploads, installs, push, MCP, remote machines and clouds) | ✓ "No event is looser than «Coda default». 17 events are stricter"; 39 deny · 13 ask · 4 allow |
| `relaxed-prototypes` | «Relaxed for prototypes»: 9 events allowed that Coda default asks about | **!** «9 looser»: delete files no checkpoint covers, write secret files, discard uncommitted work, push, download and run, run migrations, destructive commands on a local database, call MCP tools, edit CI pipelines |
| `zz-invalid-policy` | Test item: an unknown event | **invalid**: `policy.json: unknown event "net.teleport"` |

### Workflows (`workflows/`: WORKFLOW.md + workflow.json; compared with «Coda complex»)

| Item | What it does | Import |
|---|---|---|
| `bugfix-first` | Maintenance: bugs always reproduced and judged, regression test from M; features accepted by you at every size; no Lead Architect | **!** «11 looser», e.g. "feature/M: no spec, security · only when needed: docs", "No Lead Architect for disputes and L designs"; info "3 phases more" |
| `docs-project` | Docs repos: «Write» / «Fix» / «Edit» tasks, an «Outline» for M and L, docs-specific sensitive paths and «Ask me» groups (`ask_me`) | **!** «12 looser», e.g. "bug/S: no reproduce, security · implement 0 judges (1) · accepted by nobody (a judge)", "Not sensitive any more: **/auth/** … and 15 more" |
| `zz-invalid-workflow` | Test item: an unknown phase | **invalid**: `workflow.json: template feature/S: phase "deploy" is not one of research, clarify, spec, design, …` |

### Agent definitions (`definitions/`: DEFINITION.md + definition.json; checked against this machine)

| Item | Configuration | Import |
|---|---|---|
| `claude-opus-planner` | Claude Code · `opus` · high · Planning, Review | ✓ (when Claude Code offers `opus` with effort high) |
| `codex-builder` | Codex · `gpt-5.5` · medium · Building | ✓ (when Codex offers `gpt-5.5`; Codex 0.162 does) |
| `zz-unavailable-model` | Claude Code · `claude-imaginary-9-preview` · high · Research | **!** «1 missing here»: "The model claude-imaginary-9-preview is not offered by Claude Code on this machine" (importable) |
| `zz-invalid-definition` | Test item: a trailing comma | **invalid**: `definition.json is not valid JSON: invalid character '}' looking for beginning of object key string` |

A definition whose CLI isn't installed shows "… is not installed on this machine" instead.

Importing only makes an item available in the Library: read-only, with its origin and «Check for updates»;
«Duplicate» it to change it. Nothing is applied to a project by itself.
