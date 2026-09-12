# AGENTS.md — importerterraform

Context for AI coding agents (Claude Code, Codex, opencode, Cursor, …) working in
this repo. Read this first.

## What this is
A tiny, legacy **Terraform EC2-import helper** (last touched 2022). It bulk-imports
existing EC2 instances into Terraform state instead of creating new ones: `importer.sh`
lists instance IDs, stamps them into a template, and runs `terraform import` per ID.
It is not a module and not deployable infrastructure.

Current state: **parked / legacy utility**. No provider pin, no backend, no CI.

## Layout
- `importer.sh` — the whole tool: `aws ec2 describe-instances` → `instances.txt` → a
  loop that appends a resource block to `config.tf` and imports each ID.
- `configtemp.tf` — the resource template; the placeholder word `example` is replaced
  with the real instance ID by `importer.sh`.
- `config.tf` — committed **empty**; it is the generated output file.

## Commands
- Requires a local `aws` CLI with working credentials and `terraform` on PATH:
  `bash importer.sh`
- No test, lint, or CI setup in-repo.

## Gotchas
- The shebang is broken (`#/bin/bash`, missing `!`) — invoke it as `bash importer.sh`,
  not `./importer.sh`.
- It **mutates the working tree** (rewrites `config.tf` via `sed`, writes
  `instances.txt`) and runs `terraform import` one instance at a time — only ever run
  it in a scratch checkout, never where you intend to push.
- `config.tf` is a generated artifact that is nonetheless committed; treat diffs there
  as output, not source.
- Workspace rule (see `~/.openclaw/workspace/AGENTS.md`): real Terraform is applied via
  GitHub Actions, never locally. This repo predates that rule and is a manual import
  utility only — don't wire it into a pipeline.
