# Handoff — Systemic Runtime to Observable Godot Living Simulation

Status: **COMPLETED**

## Objective that was transferred

Deliver the first continuously observable and calibratable Godot living-simulation scene for Wilson Shipwrecked using the real runtime boundaries and deliberately readable primitive geometry.

That objective is now complete.

---

# Completion checkpoint

Integrated main checkpoint after PR #74:

```text
e9cf01aab57a18520a4a2d0a52fa7f3a91a839dd
```

Latest operator-reported strict local validation before squash integration:

```text
RESULT: 131 PASS / 131 TOTAL
PASS headless_suite (131 tests)
```

Validated scene:

```text
tools/living_simulation/living_simulation.tscn
```

The scene now provides:

```text
continuous GodotSimulationHost execution
explicit semantic-to-Godot bindings
Wilson autonomous movement/action
Hunger → food
Energy → rest
Stimulation → curiosity/exploration
persistent shelter project work
weather/context interruption
post-project rain response from idle
Gerald shallow physical locomotion
compact operator readout
1x / 4x / 16x execution controls
primitive-shape world readability
Wilson expression bubbles projected from semantic state
10-minute accelerated stress coverage
```

The operator manually validated the composed loop as coherent and increasingly interesting.

---

# Important integration discoveries closed during this phase

The living scene exposed real runtime gaps that were fixed rather than hidden in presentation code:

1. active `ActionExecution` uniqueness across intention replacement, including orphaned post-commit tails;
2. same-intention continuity without duplicating an active execution;
3. fresh sequential actions under the same persistent intention once the prior action is terminal;
4. weather/context routing that can interrupt ordinary activity;
5. `TACTICAL` candidates selectable from idle as well as while another intention is active;
6. navigation-map/path readiness pressure in real-engine fixtures;
7. bounded drive calibration so needs recur without starving persistent work;
8. operator time acceleration validated against the current Godot motion cadence.

Presentation remained non-authoritative throughout.

---

# Product/calibration findings carried forward

The phase also exposed several non-blocking design pressures:

```text
idle time can still become flat after major project completion
stimulation is a natural place for bounded boredom/idle acceleration
Gerald is currently mostly ambient despite real movement/relationship state
weather affects choice, but protection/degradation breadth is underused in the playground
learning/history foundations are stronger than their current visible impact
player/Presence intervention should come after the autonomous loop is interesting enough to perturb
```

The operator specifically suggested increasing Stimulation more quickly during genuine idle, conceptually as boredom. `BEHAVIORAL_MODEL.md` already supports stimulation as the anti-stagnation drive, so this should not become a separate generic boredom owner.

---

# Historical decisions that remain valid

- Primitive geometry is presentation, not semantic identity.
- `RuntimeWorldRef` / `DomainId` remain the identity boundary.
- Debug UI and bubbles are projections only.
- The living scene uses common runtime/bootstrap boundaries rather than a second debug architecture.
- Time acceleration must preserve semantic/runtime invariants.
- Do not generalize scene-binding/host composition until repeated concrete pressure justifies a stable boundary.
- Headless semantic assertions remain primary correctness evidence; manual observation is legitimate for readability/calibration.

---

# Superseding handoff

Active work now transfers to:

```text
docs/handoffs/observable-living-simulation-to-entertaining-systemic-diorama.md
```

This document is historical transition evidence only. It is no longer the active project handoff.
