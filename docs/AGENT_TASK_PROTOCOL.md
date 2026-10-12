# Task Agent Protocol: Experience → Spec → Tests → Delivery

## Roles and handoff

- **Operator (product/UX owner):** defines intended experience and accepts player-visible behavior.
- **Macro architect/orchestrator:** reviews completed work, selects the next bounded Issue, protects cross-system architecture and decides whether an escalation changes priority/scope.
- **Task agent:** investigates edge cases, proposes implementation, maintains tests and evidence, and raises consequential decisions instead of expanding scope autonomously.
- **Parallel Blender agent:** uses `art/FUNCTIONAL_ASSET_FACTORY.md`, including the pre-model consultation; runtime and Blender work must not conflict.

After each PR/task, operator tells macro architect what was delivered, which tests ran, and what was observed. Architect reviews open follow-ups and supplies a brief prompt pointing to the chosen Issue. A short prompt is a **routing instruction**, not a duplicate specification.

## Mandatory initial workflow

1. Read `AGENTS.md`, `WORKFLOW.md`, the selected Issue, and only relevant canonical contracts.
2. Inspect the actual state of `main`, existing PRs and tests. Create a short-lived task branch from current main; continue an existing branch if the task is a PR completion.
3. Use the Issue as the **living task brief and evidence log**. Use the [task template](../.github/ISSUE_TEMPLATE/task.md). Do **not** create a new permanent document simply for status reporting.
4. First write the expected user-visible causal trace, edge cases and acceptance criteria. If domain contract changes, update only the owning canonical spec. For a complex undecided feature, use a short disposable `docs/design/` decision brief only if needed for review.
5. Choose consultation depth below; ask the operator *before implementation* when behavior is not settled.
6. Write focused failing tests where executable; then implement the smallest coherent vertical slice. Record exact checks run and caveats.
7. Update Issue/PR evidence, request operator smoke only at a meaningful checkpoint, and stop for architect review. **Never self-merge.**

## Interview policy — minimum useful interruption

| Level | When | Operator interaction | Agent autonomy |
| --- | --- | --- | --- |
| I0 — None | Bug fix with unambiguous expected outcome, tests and existing contract | No interview; cite the existing contract | Investigate edge cases and implement |
| I1 — Micro | One or two ambiguous UX outcomes affect choices (e.g. failed interaction, feedback, retry cadence) | 1–3 short questions, **recommended defaults**, and one observable example | Technical design after answer |
| I2 — Focused | New feature with several meaningful states, affordances or choices | 5–8 precise questions in one brief round, with 2–3 representative situations | Map edge cases, propose bounded spec and implement approved slice |
| I3 — Discovery | New gameplay loop, high-impact emotion/UX, irreversible behavior, mortality, major balance or rules | Short design brief with options/tradeoffs, scenario walkthrough; deliberate operator sign-off **before code** | Research, prototype/tests only after decision |

Do not ask about normal technical implementation choices (class layout, deterministic test fixture, node hierarchy) unless they change the user-visible experience, violate an established invariant, or create a consequential tradeoff. An agent should **recommend** rather than outsource problem-solving to the operator. Operator silence is not approval.

The agent owns edge-case exploration: no resources, stale belief, hidden changes, interruption, recovery, replay/load, timing, finite bounds, multiple seeds, and explainability. Test only cases relevant to the slice; do not build a generalized framework to cover hypothetical future needs.

## Escalation to macro architect

**STOP and escalate** when:
- required scope grows beyond Issue acceptance or touches a new authoritative domain owner;
- a canonical contract must change across subsystems, or a major refactor is proposed;
- a different Issue/dependency is required first;
- an existing architectural rule appears inconsistent or blocks the requested UX;
- extra systems would be needed merely to make the implementation convenient;
- runtime/asset concurrent edits or risky branch operations overlap.

Escalation format (short): **Observed blocker → user-visible consequence → options (including minimum safe option) → recommendation → specific decision requested → files/issues affected**. Continue isolated safe work only; do not silently proceed with disputed scope.

Normal local refactors within established ownership and acceptance are permitted. If there is no current blocker, record optional enhancements as follow-up candidates, not tasks undertaken.

## Delivery and review handoff

A PR must report tested commit, changed owner/spec, RED→GREEN evidence, verification ladder V0–V5 from `WORKFLOW.md`, exact commands/results, operator smoke recipe if required, open risks, and proposed follow-ups. Operator reports smoke findings; macro architect decides merge readiness and next priority. Passing tests is not a substitute for player-visible acceptance when applicable.

Prefer **one Issue → one bounded PR**. No accumulating status/handoff documents or speculative future-roadmap checklists.
