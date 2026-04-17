# Platform Defaults

These are the shared production defaults for projects deployed from the Linux VM primary runtime.

## Shared Infrastructure

- production SSH target: `linuxvm`
- production server user: `blackbird`
- production server root for apps: `/home/blackbird/services`
- standby role: `backup-blackbird`
- primary Cloudflare Tunnel ID: `976ecdef-0d8f-4cbd-aaad-a4afecc0f2d4`
- standby Cloudflare Tunnel ID: `23a4d75c-1b20-49fa-83f3-1a4cd23ffc15`
- production branch: `main`
- image registry: `GHCR`

## Route Interpretation Rules

- `linuxvm` is the canonical primary runtime and operator truth.
- `backup-blackbird` is the standby role used by deploy-platform.
- `chiasegpu-vm` is a legacy rented-server route and must not be assumed equal to `backup-blackbird`.
- Raw endpoints such as `e1.chiasegpu.vn:44518` are route data, not identity truth.
- Ports `22`, `44518`, and `55463` on the same hostname must be verified independently by SSH banner and fingerprint.
- If a route accepts TCP but does not emit `SSH-2.0-...`, treat it as broken or stale.
- If live fingerprint differs from stored historical fingerprint, classify it as route drift and stop assuming it is the same host.

## Naming Convention

- app hostname: `<project-slug>.blackbirdzzzz.art`
- browser hostname: `browser-<project-slug>.blackbirdzzzz.art`

Rationale:

- single-label subdomains reduce certificate and wildcard complications
- the browser hostname pattern is deterministic, so Codex can infer it without asking

## Rollback Convention

- default rollback target: `previous_sha`
- explicit rollback target: any SHA requested by the user

## Golden Reference Repo

Use active Linux VM production repos as references:

- `/home/blackbird/services/hybrid-agent-platform`
- `/home/blackbird/services/openclaw-edge`
- `/home/blackbird/services/openclaw-reader`
- `/home/blackbird/services/teda-insight-model`

## Registry

The local project registry on the Linux VM lives at:

- `/home/blackbird/workspace/openclaw/deploy-platform/projects.yml`

Each onboarded project should end with an entry in that file.
