# Agent Workflow & Verification Contract

This document owns repository **delivery process**, not game-domain architecture. Read `AGENTS.md` for global authority invariants and `docs/README.md` for task-specific canonical sources.

## One authority for each question

- Product intent and stage maturity: `PRODUCT.md` / `DEVELOPMENT_STAGES.md`.
- Domain/architecture/art contract: relevant canonical document.
- Implementation truth: code, tests, last **executed** validation evidence.
- Task objective: GitHub Issue.
- Proposed implementation and evidence: PR.
- Current integration priorities: `PROJECT_CONTROL.md`.
- Review/handoff: temporary context; never override a canonical source.

## Parallel art exception

Runtime integration stays serial where contracts overlap. Blender production is the explicitly allowed parallel lane, led by a local Blender-capable agent, operating on independent art branches/PRs. The art EPIC may be continuous but each model is a bounded individually consulted unit. See [art/FUNCTIONAL_ASSET_FACTORY.md](art/FUNCTIONAL_ASSET_FACTORY.md). Art PR completion does **not** imply Godot/runtime integration. Reuse V-level evidence as actually performed; operator consultation occurs **before** the model is created.

For operator interviews, handoff cadence, agent autonomy and architect escalation, follow [AGENT_TASK_PROTOCOL.md](AGENT_TASK_PROTOCOL.md). GitHub Issue templates under `.github/ISSUE_TEMPLATE/` are the task's living spec/evidence log; create separate design documents only when the canonical contract or complex discovery needs them.

## EPIC → TASK → PR

**EPIC**: bounded product/technical risk, observable outcome, exit gate, dependencies; no implementation checklist masquerading as a stage.

**TASK**: a reviewable vertical slice generally completed on one short-lived branch and one PR. The Issue template below can be copied when assigning work.

```md
## Product pressure / why
## Observable behavior / spec
## Required reading (only necessary canonical paths)
## Architecture boundaries / prohibited shortcuts
## Acceptance criteria (semantic + player-visible, if applicable)
## Red tests / focused TDD evidence
## Validation plan (automated and operator)
## Dependencies / integration order
## Explicitly out of scope
## Follow-up candidates (not authorized scope)
```

No agent may widen the scope to build adjacent general systems without operator/macro-architect approval. Record unknowns and proposals on the Issue. Do not turn PR bodies or new docs into perpetual task registers.

## SDD + TDD

1. Identify the existing contract owner and the required behavior **before coding**.
2. Change the smallest canonical spec first if semantics change; otherwise the Issue acceptance criteria are the operative slice spec.
3. Write a focused failing regression first where runnable, or author a test with an explicitly **NOT EXECUTED** label if local tooling is absent.
4. Implement the smallest valid change through the existing owners/ports and run focused checks available in that environment.
5. Run full strict tests **at integration checkpoint** where available. Preserve the operator's preference against manual smoke-testing every internal slice.
6. Record evidence, limitations and follow-ups in the PR. Do not state a check passed when it was not executed.

## Verification ladder

These levels are **evidence classifications**, not interchangeable approvals:

| Level | Evidence |
| --- | --- |
| V0 Reasoned | Review/inspection only; no code execution |
| V1 Static | Static tooling or structural/pipeline checks actually run |
| V2 Automated | Focused tests actually executed |
| V3 Integration | Entire required strict suite actually executed |
| V4 Operator smoke | Richard runs Godot/Blender or the packaged scene in his environment |
| V5 Player-visible acceptance | Richard judges causal readability / visual intent / game-feel |

Report each level as **PASS / FAIL / NOT RUN / NOT APPLICABLE**, with actual command, environment and scope. V0/V1 cannot imply V2/V3; automated green cannot imply V4/V5. Existing historical results cannot certify a newer SHA. An agent lacking Godot cannot claim Godot runtime success. A PR can await V4/V5 with an explicit manual recipe. Documentation-only changes do not demand runtime smoke tests.

Operator handoff must be short: exact ref/SHA, command/scene to open, 2–5 observable expectations, screenshots/log excerpt requested on failure, and what result unblocks merge.

## Branches and PRs

- `main` is the sole integrated truth. Branch from current `origin/main`; PR targets `main`.
- Prefer **one active integration lane for conflicting runtime contracts**. Unrelated art work may run concurrently on independent files/branches. Avoid editing shared hotspots in parallel.
- Do not stack task branches on unmerged branches without explicitly documented exception and integration order.
- One branch per coherent task slice. Open a **Draft PR early** for substantial work, so branch ownership and scope are visible.
- Sync from `main` when affected contracts/files change, not reflexively. Avoid rebase/force push on shared branches without coordination.
- A review-ready PR should name linked Issue, scope, authority changes, test outcomes by V-level, manual smoke instructions/status, and deferred work.
- No agent merges without explicit authorization **for that PR**. After an authorized squash merge, clean up merged branches/worktrees only once local-only work is ruled out.
- Untracked/ignored, locally modified, or unpushed files must be inventoried before cleaning, switching branches, or deleting worktrees.

## Documentation scale

- Prefer minimal diffs to existing owner documents; use headings and narrow sections.
- Keep coordination/policy docs compact. Link to contracts rather than duplicating them.
- Large canonical technical documents may remain long when concepts are tightly coupled; avoid splitting simply by line count.
- Do not create `*_V2`, `*_NOTES`, `*_REFINEMENTS`, one document per feature, or a new active handoff per task.
- Historical handoffs and reviews need not be deleted to clean governance. Archive them logically by removing *active* claims and keeping their evidence.
- Technical changes update contracts; PR/Issue status alone should **not** cause rewrites of technical documents.
