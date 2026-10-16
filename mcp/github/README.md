# github-mcp-server (MCP server, URL)

GitHub's hosted MCP server at `https://api.githubcopilot.com/mcp/`, reached over streamable HTTP.

It needs a token in the `Authorization` header. Coda turns the header `Bearer {GITHUB_MCP_TOKEN}` into the secret
**GITHUB_MCP_TOKEN**, sent as `Bearer {secret}`. Before you use it: «Library» → «Secrets» → «＋ Add secret»
`GITHUB_MCP_TOKEN` (a GitHub personal access token) with the host `api.githubcopilot.com` — a URL server gets a
secret only when its host is in the secret's hosts; otherwise Coda leaves the server out at launch and says why.

Coda imports it as the Library server **github-mcp-server** (a URL server).
