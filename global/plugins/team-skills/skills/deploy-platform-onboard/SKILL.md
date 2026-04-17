---
name: deploy-platform-onboard
description: >
  Use when the user asks to "setup deploy flow", "onboard project production",
  "cau hinh project theo flow deploy", "dua project len production", "setup GHCR deploy",
  "tao metadata deploy cho project", "onboard project len vm linux", or wants Codex
  to read a project's docs, infer production metadata, propose or fill the intake fields,
  and align the repo to the current Linux-VM-first production workflow.
---

# Deploy Platform Onboard

Use this skill when a project needs to be aligned to the shared production workflow:

- GitHub `main` is the production source of truth
- GitHub Actions builds the production image to GHCR
- `linuxvm` is the primary production runtime
- `backup-blackbird` is optional standby runtime
- Cloudflare ingress uses primary tunnel with optional standby tunnel failover
- final production verification runs through `ssh linuxvm '~/bin/prod-audit'`
- reboot safety verification runs through `ssh linuxvm '~/bin/prod-reboot-check'`

Important framing:

- This skill does not start by SSH-ing into a VM.
- It starts by reading repo truth, then platform truth, then runtime credential truth.
- `linuxvm` is the primary runtime.
- `backup-blackbird` is the logical standby node in deploy-platform.
- `chiasegpu-vm` is a legacy rented-server route and must not be conflated with `backup-blackbird`.
- If a raw standby SSH endpoint appears in docs or `projects.yml`, verify its live banner and fingerprint before treating it as a valid admin route.

## Read First

- `/Users/nguyenquocthong/project/openclaw/topics/deploy-platform/README.md`
- `/Users/nguyenquocthong/project/openclaw/topics/deploy-platform/projects.yml`
- `/Users/nguyenquocthong/project/openclaw/topics/deploy-platform/AUTOMATION.md`
- `references/platform-defaults.md`

Priority rule:

1. shared deploy-platform docs
2. active project runtime docs
3. repo runtime files
4. only then raw SSH endpoints if the task actually requires touching a machine

## Inputs To Fill Or Propose

The target intake block is:

```text
- project_name:
- project_slug:
- github_repo:
- app_dir_on_server:
- app_port:
- browser_port:
- healthcheck_url:
- runtime: docker compose
- env_file_path:
- has_browser_ui:
```

## Discovery Workflow

1. Read the project docs and runtime files before proposing anything. Prioritize:
   - `README*`
   - `docs/**/*deploy*`
   - `docs/**/*production*`
   - `docker-compose*.yml`
   - `Dockerfile*`
   - `.env.example`, `.env.*.example`
   - backend entrypoints and health routes if healthcheck is not documented
2. Infer the intake fields with the following defaults:
   - `project_slug` = kebab-case `project_name`
   - `app_dir_on_server` = `/home/blackbird/services/<project-slug>`
   - `runtime` = `docker compose`
   - `env_file_path` = `/home/blackbird/services/<project-slug>/.env`
   - `has_browser_ui` = `yes` only if docs or compose files clearly expose noVNC, VNC, Playwright browser UI, or similar
3. If confidence is high, update `/Users/nguyenquocthong/project/openclaw/topics/deploy-platform/projects.yml`.
4. If one or more fields are uncertain, present a proposed block to the user and ask only for the missing decisions.

Do not jump from a hostname in a stale doc to "this is the production machine".
When docs, live banner, and fingerprint disagree, treat that as topology drift and surface it explicitly.

## Runtime Credential Resolution

Before concluding that Cloudflare automation is blocked, check runtime credentials in this order:

1. source `~/.config/blackbird-deploy/load_runtime.sh` if it exists
2. `PLATFORM_ENV_FILE` if it is already exported in the current shell
3. local host file `~/.config/blackbird-deploy/platform.env`
4. local host file `~/.config/blackbird-deploy/backup.env` when R2 credentials are needed
5. Linux VM runtime file `linuxvm:~/.config/blackbird-deploy/platform.env` when the platform was previously bootstrapped there
6. Linux VM runtime file `linuxvm:~/.config/blackbird-deploy/backup.env` when R2 credentials are needed

Important:

- The Cloudflare API token is intentionally not stored in the repo.
- A prior user message containing the token does not count as a reusable runtime credential source.
- If `~/.config/blackbird-deploy/load_runtime.sh` exists, prefer it as the stable entrypoint.
- If the token exists on `linuxvm`, automation should prefer running the onboarding script there rather than claiming the platform is missing credentials.
- Do not treat credentials pasted in chat as durable production truth.
- If local runtime credentials are absent but Linux VM runtime files exist, delegate the onboarding script to `linuxvm` rather than falling back to ad hoc local guessing.

## Standby Target Resolution

When a task mentions standby, failover, or `backup-blackbird`, resolve target in this order:

1. `projects.yml`
2. deploy-platform `README.md`
3. deploy-platform `AUTOMATION.md`
4. active project `docs/production-deployment.md`
5. live route verification

Rules:

- `backup-blackbird` is the platform role; a raw SSH endpoint is only one possible route to it.
- Do not assume `e1.chiasegpu.vn:44518`, `e1.chiasegpu.vn:55463`, and `e1.chiasegpu.vn:22` are equivalent.
- If a route accepts TCP but never returns an SSH banner, classify it as broken/stale endpoint, not as a password issue.
- If the SSH fingerprint differs from historical records, stop and report route drift before any deploy or automation change.

## Setup Workflow

After the intake block is confirmed:

1. Align the repo to the standard production flow using the golden reference in:
   - `/Users/nguyenquocthong/project/openclaw/_work/social-listening-v3`
2. Add or align these repo files:
   - `.github/workflows/ci.yml`
   - `.github/workflows/build-image.yml`
   - `.github/workflows/deploy-production.yml`
   - `.github/workflows/rollback-production.yml`
   - `docker-compose.production.yml`
   - `scripts/deploy_production.sh`
   - `scripts/healthcheck_production.sh`
   - `scripts/rollback_production.sh`
   - `scripts/trigger_production_deploy.sh`
   - `scripts/trigger_production_rollback.sh`
   - `docs/production-deployment.md`
3. Reuse the existing app structure instead of forcing a blind copy. Adjust ports, image names, healthcheck path, service names, and env paths to match the target project.
4. If the production target is `linuxvm`, ensure image build and publish support both `linux/amd64` and `linux/arm64`. Do not ship amd64-only images to `linuxvm`.
5. Prefer the self-hosted runner path already used by the platform when deploy needs local network, `.local` hostnames, or direct Docker access on `linuxvm`.
6. Update `/Users/nguyenquocthong/project/openclaw/topics/deploy-platform/projects.yml` with final values after setup.
7. If runtime credentials are configured, run:
   - `/Users/nguyenquocthong/project/openclaw/topics/deploy-platform/scripts/onboard_production_infra.sh`
8. That script is responsible for:
   - Cloudflare hostname alignment on the selected tunnel
   - optional GitHub production secret bootstrap
   - optional GitHub production variable bootstrap
9. If runtime credentials are not configured, state that automation is blocked and tell the user which credential source is missing.

If onboarding touches standby automation, also verify that:

- standby route is still reachable
- standby route returns a real SSH banner
- post-deploy audit on `linuxvm` is not blocked by a stale standby endpoint

## Standardization Mode (Existing Linux VM Services)

When the target project is already running on Linux VM and the user asks to standardize production:

1. Run onboarding with `--skip-github-bootstrap`.
2. Ensure route points to the expected port on primary tunnel.
3. Preserve the current compose topology, container names, mounted volumes, and data paths unless the user explicitly asks for a migration. Do not swap a live service to a "golden reference" layout blindly.
4. Run local healthcheck and public healthcheck.
5. Confirm container status with `docker ps`.
6. If the service has standby/failover, verify standby sync and standby public URL too.
7. Finish with `ssh linuxvm '~/bin/prod-audit'`.
8. Update `projects.yml` notes/status if runtime location changed.

## Rules

1. Do not build production from local source on the VM.
2. Production deploys must target `main`.
3. Production images must be identified by commit SHA tags in GHCR.
4. Default rollback target is `previous_sha`. Support explicit SHA rollback when the user asks.
5. Do not overwrite an existing production workflow blindly. Inspect and merge with intent.
6. Keep the user involvement minimal by proposing only the fields that cannot be inferred safely.
7. Treat all ChiaseGPU-specific deploy instructions as legacy unless the user explicitly requests archival recovery.
8. Prefer sourcing `~/.config/blackbird-deploy/load_runtime.sh` over asking for Cloudflare credentials again.
9. For Linux-VM-first production, multi-arch GHCR images are mandatory, not optional.
10. Production is not complete until post-deploy audit passes on `linuxvm`.
11. `backup-blackbird` and `chiasegpu-vm` are not interchangeable labels.
12. Do not treat a raw standby SSH route as trusted until live SSH banner plus fingerprint verification succeed.

## Output

When the skill is used, end with:

- the confirmed intake block
- what was inferred vs what the user had to confirm
- which deploy files were created or aligned
- whether Cloudflare/GitHub automation was completed, skipped, or blocked
- whether `prod-audit` passed and whether reboot verification path is ready

Note: new chats will pick up this skill automatically. The current chat may not refresh the skill list until a new session starts.
