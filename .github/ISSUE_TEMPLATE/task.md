---
name: Bounded implementation task
about: One SDD/TDD vertical slice with observable acceptance
title: "task: "
labels: []
assignees: []
---

## Product pressure / user-visible outcome
<!-- Why this matters and what a player should notice. -->

## Existing contracts and dependencies
<!-- Relevant Issue/PR, canonical owner/spec paths, branch/asset boundaries. -->

## Expected causal trace
```text
precondition → action/evidence → authoritative change → perceived consequence → observable result
```

## Edge cases / invariants
<!-- Agent investigates; mark unknown UX decisions explicitly. -->

## Interview gate
<!-- I0 / I1 / I2 / I3, with rationale per docs/AGENT_TASK_PROTOCOL.md. -->
- Level:
- Questions + proposed defaults (if any):
- Operator decisions / date:

## SDD + TDD acceptance
<!-- Link changed canonical contract if needed, list focused RED regressions and real gameplay acceptance. -->
- [ ] Expected semantics and exclusions agreed
- [ ] RED tests authored/executed (or explicitly NOT RUN)
- [ ] GREEN focused validation executed (or explicitly NOT RUN)
- [ ] Required strict suite and scenario probes recorded
- [ ] Operator smoke/visual acceptance requested when meaningful

## Boundaries and explicitly out of scope

## Evidence and outcome (update during task)
- Tested SHA:
- Checks + exact results / V0–V5:
- PR:
- Observed operator outcome:
- Follow-ups (not authorized scope):

## Escalation (if needed)
<!-- Blocker → impact → options → recommendation → decision requested. -->
