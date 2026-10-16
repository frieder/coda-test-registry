---
name: strict-no-network
description: Strict - no network. Agents work only on this machine - no web reads, no uploads, no installs, no push, nothing on remote machines or clouds; everything else as in Coda default.
---

# Strict - no network

For code that must not leave the machine and for agents that must not pull anything in: a client's
repository under NDA, an audit, a review of untrusted code.

Denied on top of «Coda default» (which asks or allows them):

- reading from the web, sending data out, chat messages, opening the machine to the outside;
- MCP servers' tools (a server can reach the network);
- installing dependencies (project or system), download-and-run;
- push, changing remotes, acting on the Git host (pull requests, releases);
- revealing secrets from a secret store, copying remote databases;
- switching cloud environments, apply, deploy, running commands on other machines.

Every other event keeps Coda default's answer. Nothing is looser than Coda default, so the import shows no
warnings. Coda's policy covers what the agents ask Coda about; programs started by a build can still reach
the network - use the OS sandbox for a hard boundary.
