# Project Control

Status: OPERATIONAL INDEX — reviewed 2026-10-11. This is **not** a technical specification, a test-result claim, or an implementation backlog.

## Current product question

Stage 3 — **Entertaining autonomous diorama** (canonical maturity gate: [DEVELOPMENT_STAGES.md](DEVELOPMENT_STAGES.md)).

Can a short autonomous run yield legible, memorable causal situations, including quiet preference, experiment/discovery, actor interference, history-dependent decisions, post-project life, and readable semantic reactions?

## Control plane

- **Product intent and stage gate:** `PRODUCT.md`, `DEVELOPMENT_STAGES.md`.
- **Durable technical decisions:** owning architecture/domain/art documents (see [documentation map](README.md)).
- **Verified integrated implementation:** `DISCOVERY_STATUS.md`, source and tests; do not conflate main HEAD with last validated runtime SHA.
- **Work assignment:** GitHub Issues, one EPIC and bounded child TASKs; labels and Issue links carry live status.
- **Code/art execution:** short-lived task branch + PR against `main`.
- **Evidence:** PR validation record and operator smoke outcome, using [WORKFLOW.md](WORKFLOW.md).
- **Handoffs/reviews:** historical context and bounded transitions, not active backlog or competing authority.

## Integration queue (triage required, not permission to merge)

| Work | State at 2026-10-11 | Next action |
| --- | --- | --- |
| [PR #79](https://github.com/RrR2010/wilson-shipwrecked/pull/79) camp props | Open; 2 commits ahead, 0 behind; 14 GLBs and generator/catalog/review changes; six additions deferred from Godot import | Operator visual/import acceptance for required asset scope, then decide merge |
| [PR #78](https://github.com/RrR2010/wilson-shipwrecked/pull/78) quantities/perceptual containment | Draft; 15 commits ahead and 1 behind `main` (14 changed GDScript/test files) | Complete composition and strict validation on updated main; do not merge as-is |
| `runtime/representative-gameplay-semantics` | Remote branch: 0 commits ahead, 26 behind `main`; no open PR | Likely obsolete remotely; check any local work before deletion |
| `assets/modeling-pilot-batch-01` | Remote branch: 2 commits ahead, 27 behind `main`, changing Blender review tooling | Inspect two tooling edits for applicability before cherry-pick/rewrite; avoid deleting without local check |
| Local uncommitted or unpushed work | UNKNOWN: GitHub cannot see operator filesystem | Run read-only local audit (below); decide explicitly what to commit/push |

These observations are snapshots. Refresh against GitHub before any operation; avoid maintaining a second manual running issue tracker in this file.

## Decision / delegation policy

1. The macro architect selects a product risk, resolves ownership and dependency questions, and issues acceptance criteria.
2. An implementation agent executes only a **bounded TASK**; scope discoveries become proposed follow-ups, not automatic expansion.
3. Prefer a vertical causal slice with one observable outcome over building a new general subsystem.
4. Plan acceptance at both **semantic/TDD** and **operator/game-feel** levels.
5. Code or asset branches remain isolated. No unapproved direct `main` commits, stacked branches, or merges.
6. On task completion, update the linked Issue/PR evidence. Update a canonical document **only if its contract changed**.
7. Refresh this cockpit when priority, blocking state, or the next integration decision actually changes.

## Immediate execution order

1. Protect unknown local work: inventory working trees, untracked GLB/BLEND/generated outputs, and unpushed commits, without clean/reset.
2. Triage #78/#79 and both remote branches against current `main`; settle dependencies and acceptance criteria.
3. Only then select the first Stage-3 vertical task; existing handoff remains useful as historical candidate/evidence, **not** an instruction to implement every slice.
4. Resume runtime and art work in small isolated PRs following [WORKFLOW.md](WORKFLOW.md).

## Local operator audit

From **each checkout/worktree** (PowerShell):

```powershell
git status --short --branch
git branch -vv
git remote -v
git fetch origin --prune
git status --porcelain=v1 -uall
git log --oneline --decorate '@{upstream}..HEAD'
git ls-files --others --exclude-standard
git worktree list --porcelain
```

Inspect large and 3D file candidates without touching them:

```powershell
Get-ChildItem -Recurse -File -Include *.blend,*.blend1,*.glb,*.gltf,*.fbx,*.obj,*.png,*.webp |
  Select-Object FullName,Length,LastWriteTime | Sort-Object LastWriteTime -Descending
```

If a branch has no upstream, the `@{upstream}` command errors; check `git branch -vv` and use `git log origin/main..HEAD --oneline` as a baseline, while remembering it may include already-merged commits after squash. Share the output, **not** whole asset binaries. Do not run `git clean`, `reset --hard`, force push, deletion, or merge before classification.
