# Project / Need Continuity Pressure

Status: OPEN

Active implementation pressure on `feat/systemic-project-need-continuity`.

## Representative question

Can Wilson autonomously continue a partially completed project until a competing need becomes more important, resolve that need, and later return to the still-meaningful project without scene-specific scripting?

## Admission rule

Do not introduce a routine owner, generic planner, arbitrary intention stack, or project-specific control path. First compose the existing project, drive, decision, intention, action, reconsideration, and persistence contracts. Add only the smallest reusable semantic primitive demonstrated missing by the representative scenario.

## Finding

Existing project and drive candidates already share ordinary intentional competition. No new priority/routine owner was required.

The representative sequence exposed one orchestration gap: after a real `ActionProgressResult.completed` boundary, the scenario otherwise had to inject `ACTION_OR_INTENTION_COMPLETION` from outside to make the next ordinary choice. That contradicts the canonical orchestration contract, which allows reconsideration triggers to be derived during the same causal chain from newly admitted boundary facts.

Implemented pressure-specific fix:

```text
ActionExecution.advance
→ ActionProgressResult.completed
→ SimulationOrchestrator derives ACTION_OR_INTENTION_COMPLETION
→ normal coalesced reconsideration
→ ordinary candidate competition
```

This is deliberately based on `completed`, not `new_outcome`/commit, so post-commit execution tails remain distinct from terminal completion.

## Evidence added

- `action_completion_reconsideration_test.gd`: focused regression proving a completed action opens normal reconsideration without an external trigger;
- `project_need_continuity_scenario_test.gd`: representative sequence proving project contribution → growing hunger → food interruption → grounded hunger relief → autonomous return to persistent project progress.

The long scenario uses one initial `PROJECT_CHECKPOINT` to enter the project loop. After that point it injects no completion/drive triggers; action completion and drive-band transition carry the sequence.

## Exit condition

The block is closed when the strict headless suite is green for the branch and the representative sequence demonstrates:

```text
partial project
→ contribution
→ growing competing need
→ autonomous reconsideration/interruption
→ need resolution
→ persistent project progress
→ project becomes eligible/attractive again
→ later autonomous contribution
```

Validation is still pending because the current agent environment has neither a Godot executable nor network access for cloning/running the repository locally.
