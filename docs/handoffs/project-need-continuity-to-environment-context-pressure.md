# Handoff — Project / Need Continuity to Environment / Context Pressure

Status: Active stage-transition handoff after PR #65 integration.

## Stage completed

The systemic gameplay expansion has now closed its first richer living-sequence pressure:

```text
unfinished project
→ repeated grounded contribution
→ hunger grows through ordinary drive progression
→ pressing hunger joins normal intentional competition
→ hunger temporarily displaces project work
→ grounded food action resolves hunger
→ terminal action completion opens reconsideration
→ unfinished project remains meaningful
→ Wilson returns to the same persistent project
→ later contribution continues prior progress
```

This sequence is implemented on `feat/systemic-project-need-continuity` / PR #65.

Strict operator validation:

```text
RESULT: 106 PASS / 106 TOTAL
PASS headless_suite (106 tests)
```

No runtime/test changes were made after that validated executable tree; later branch changes only closed documentation and removed a temporary unvalidated environment-pressure scaffold so the final executable tree remains the validated one.

## Durable semantic result

No routine owner, planner, generic priority manager, arbitrary intention stack or project-specific controller was required.

Existing `ProjectCandidateSource` and `DriveCandidateSource` already compete in ordinary intentional routing. The only missing causal bridge exposed by the representative scene was action completion itself.

The durable orchestration rule is now:

```text
ActionExecution.advance
→ ActionProgressResult.completed == true
→ SimulationOrchestrator derives ACTION_OR_INTENTION_COMPLETION
→ coalesced reconsideration
→ ordinary candidate competition
```

Important negative rule:

```text
commit != completion
```

A committed action still in a post-commit tail does not by itself trigger broad reconsideration. The focused regression covers both sides of this boundary.

## Evidence

Primary regressions:

- `tests/headless/action_completion_reconsideration_test.gd`
- `tests/headless/project_need_continuity_scenario_test.gd`

Review evidence:

- `docs/design-reviews/2026-09-07-project-need-continuity-pressure.md`
- `docs/design-reviews/2026-09-07-environment-context-interruption-pressure.md`

The environment review is intentionally closed as a scope-boundary finding, not as implemented gameplay.

## Required next-agent start

Start only from merged `main`. Do not stack a new task branch on unmerged PR #65.

Read:

1. `AGENTS.md`
2. `docs/README.md`
3. `docs/DISCOVERY_STATUS.md`
4. this handoff
5. `docs/PRODUCT.md`
6. `docs/BEHAVIORAL_MODEL.md`
7. `docs/SCENE_VALIDATION.md`
8. `docs/brainstorming/representative-scene-catalog.md`
9. environment/domain contracts only when the selected pressure requires them

Treat `docs/handoffs/foundational-causality-to-systemic-gameplay-expansion.md` as prior transition context, not the leading handoff after this one.

## Recommended next vertical

The next strong pressure is **environment/context interference with ordinary activity**.

Target player-visible shape:

```text
Wilson is doing ordinary work / pursuing an unfinished project
→ an authoritative environment transition changes current desirability or possibility
→ Wilson perceives/experiences enough context for the change to matter
→ CONTEXT_TRANSITION or another grounded semantic boundary opens reconsideration
→ Wilson redirects to a context-appropriate activity
→ prior project state remains persistent rather than being erased
→ when context changes again, the project can become attractive and continue
```

The important product question is not merely whether weather values can change. It is:

> Can the environment alter Wilson's ongoing day in a way the player can read causally, while preserving continuity of unfinished life?

## Why this is a new block

A repository search during PR #65 found no concrete `weather` / `rain` gameplay implementation path or existing environment-context candidate source sufficient to express that scene as a tiny extension of the project/need work.

Therefore, implementing the pressure would likely require choosing the first concrete environment semantics/content rather than merely composing already-proven sources. That is a qualitative focus change and should begin from a fresh branch after PR #65 merges.

Do not treat this as permission to build a general weather system.

## Admission questions for the next vertical

Before adding runtime structure, answer:

1. Which exact player-visible environmental situation are we proving?
2. Which authoritative owner already contains the relevant environment truth?
3. What does Wilson actually perceive/experience, as distinct from hidden environment truth?
4. Can an existing drive/project/opportunity/habit candidate express the changed desirability?
5. If not, what is the smallest reusable environment-conditioned candidate/evaluation contract?
6. Which boundary emits or derives the meaningful context-transition reconsideration trigger?
7. Does unfinished project/history persist through the interruption?
8. Can the same rule support more than this fixture without becoming a generic weather framework?

## Suggested first pressure

Prefer something smaller than a full storm simulation. Example:

```text
ordinary exposed project work
→ rain / heat / wind crosses one authored meaningful state
→ Wilson's comfort or activity suitability changes
→ Wilson seeks shelter / changes activity through normal competition
→ project remains unfinished
→ environment returns to acceptable state
→ project becomes competitive again
```

Choose whichever environmental fact is easiest to ground in existing World/environment owners and player-visible enough to justify the new primitive.

## Explicit anti-goals

Do not start with:

- generalized weather taxonomy;
- universal environment-condition DSL;
- generic planner or routine scheduler;
- arbitrary interruption stack;
- global context blackboard;
- hidden weather truth directly writing Wilson cognition;
- broad environment simulation merely because environment owners already exist;
- UI narration as a substitute for durable causal traces.

## Block boundary for the next agent

A good next block ends when one concrete environment transition can interrupt and later release an ordinary persistent activity through existing cognition/decision machinery, with a strict green suite and a representative regression.

Do not continue in the same block into Gerald expansion, player suggestion/refusal, scientific experimentation, object reputation or full daily-routine breadth unless the chosen environment scene genuinely requires one of those contracts.

## Integration note

PR #65 must still receive explicit operator merge authorization. Use squash merge. After merge, refresh `main`, create a fresh short-lived branch for the environment/context vertical, and update `docs/DISCOVERY_STATUS.md` as appropriate for the integrated 106-test baseline.
