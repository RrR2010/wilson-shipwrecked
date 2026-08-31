# Architecture Implementation Gate

## Decision

The behavioral/architecture contract phase, including the final pre-domain gameplay review, is **complete enough to proceed into concrete implementation design**.

Current gate status:

| Next step | Gate |
|---|---|
| Concrete domain data model | **READY** |
| Domain/application/Godot package layout | **READY** |
| First implementation vertical slice | **READY AFTER the minimal data model/package boundary is defined as part of implementation kickoff** |

There are no remaining product-psychology or cross-system-authority blockers that require another discovery cycle before implementation design begins.

The final gameplay review added/refined several implementation-facing contracts without reopening the architecture:

- interaction/crafting resolution is property/capability/context-driven rather than an object-pair recipe catalog;
- eligible exploration produces knowledge from observed results rather than a separate random discovery gate;
- player-facing semantic interaction knowledge normally follows Wilson's discovered knowledge;
- God Power amount does not unlock new intervention capabilities;
- supported player interventions may have lethal grounded consequences;
- resurrection is free and unlimited, while End Run permanently closes the world;
- selected cross-run Legacy Knowledge is player-side global state, not Wilson autobiographical memory;
- one Diary surface combines Wilson-grounded run narrative with clearly player-level statistics/archive records;
- Luck is bounded chance favorability derived from normally-owned modifiers, not a Wilson psychological trait or event-frequency control;
- no persistent `chaoticity` state is required for pacing.

This does **not** mean the architecture is immutable or that all balance/formulas are known. It means the responsibility graph, semantic handoffs, update ordering and mutation ownership are specific enough that concrete types can now be designed without encoding known ambiguity.

---

# 1. Evidence used for the gate

The gate is based on the following canonical artifacts:

1. `BEHAVIORAL_MODEL.md` — validated minimum behavioral model;
2. `STATE_REQUIREMENTS.md` — persistent/derived state inventory and cross-run Legacy semantics;
3. `SCENE_VALIDATION.md` — Must-have matrix and regression suite;
4. `ARCHITECTURE.md` — system boundaries and composition strategy;
5. `GUARDS_AND_CALIBRATION.md` — bounds and self-stabilization constraints;
6. `SIMULATION_CONTRACTS.md` — semantic cross-system contract catalog;
7. `SIMULATION_ORCHESTRATION.md` — clocks, ordering, reconsideration and interruption semantics;
8. `MUTATION_AUTHORITY.md` — explicit read/propose/mutate/observe authority matrix, including player-profile/Legacy/Diary boundaries;
9. `DECISION_TRACES.md` — end-to-end validation across representative integration scenes;
10. `PRODUCT.md` and `SIMULATION.md` — final gameplay envelope for open-ended progression, property-driven interaction/discovery, Luck, God Power, death and cross-run history.

The validated traces cover:

```text
Scientific Method
Sabotaged Storage
Brilliant Shortcut
Falling Palm
```

No trace required a new broad psychological primitive, shared mutable owner or scene-specific architectural bypass.

---

# 2. Gate criteria

## 2.1 Central state ownership is unambiguous — PASS

Durable/authoritative state families have one normal owner.

Critical ownership boundaries are explicit:

```text
World Simulation
  → authoritative physical/world truth
  → source state for world/content Luck modifiers

Wilson Cognition
  → traits, drives, beliefs/knowledge, associations, habits,
    episodic history, intentions, presence relationship

Project System
  → project lifecycle/progress metadata

Player-side domain
  → active-run God Power/permissions/suggestion state
  → global Legacy Knowledge / lifetime statistics / Diary archive metadata

Event / Scene Director
  → event eligibility/cooldowns/active authored premise state

Action Resolution
  → authoritative action validation/execution state/result semantics
```

`Player-side domain` is an authority family, not a requirement for one giant class. Concrete layout may separate intervention and player-profile aggregates/modules.

Persistence serializes/restores these owners but does not become an owner itself.

Cross-owner effects use proposals/results/bootstrap projections rather than arbitrary shared writes.

---

## 2.2 World truth / observation / belief separation is explicit — PASS

Canonical chain:

```text
WorldEvent
→ ObservedEvent / PerceptionResult
→ LearningEvidence
→ BeliefEvidence / other owner-specific proposals
→ owner-local mutation
```

The architecture supports:

- Wilson being wrong;
- Wilson observing an effect without its cause;
- incorrect category inference;
- causal ambiguity;
- presence attribution;
- player knowledge differing from Wilson knowledge;
- hidden Luck modifiers existing without automatically becoming Wilson knowledge.

---

## 2.3 Property-driven interaction/crafting boundary is explicit — PASS

The generic interaction model is not an object-pair recipe table.

Canonical direction:

```text
semantic action roles
+ participant properties/capabilities
+ contextual predicates
→ authoritative effect/transformation
```

Example intent:

```text
impact-tool capability + sufficient hardness/impact
+
breakable target + compatible resistance
→ target transformation
```

rather than:

```text
stone + coconut = opened coconut
hammer + coconut = opened coconut
...
```

Transformation forms and exceptional content remain authored/bounded, but compatible source participants may satisfy reusable predicates procedurally.

Wilson's learned semantic interaction is separate from the authoritative physical rule.

---

## 2.4 Discovery boundary is explicit — PASS

Content may gate an exploration/hidden possibility through semantic prerequisites such as knowledge, equipment, properties, location, proximity and environmental state.

Required chain:

```text
prerequisites satisfied
→ physical/generic exploration becomes available when encountered
→ Wilson performs/encounters it
→ grounded result is observed
→ semantic knowledge is acquired/generalized according to content scope
```

There is no additional RNG gate whose only purpose is to hide an already-observed meaningful result.

The normal player-facing rule is that semantic interaction knowledge becomes visible when Wilson learns it. Generic exploration may be suggested before its result is known.

---

## 2.5 Decision contract is explainable and bounded — PASS

Normal decision flow is explicit:

```text
DecisionContext
→ CandidateIntention[]
→ EvaluationContribution[]
→ CandidateEvaluation[]
→ seeded selection
→ SelectedIntention
```

Each semantic contribution has finite influence.

Traits modulate only semantically related evaluators.

Hidden effective Luck does not directly modify Wilson intention score.

The design does not require one opaque universal rational score or global GOAP brain.

---

## 2.6 Reconsideration semantics are explicit — PASS

Wilson does not replan every render/simulation tick.

Triggers are coalesced and debounced.

Current intention receives bounded hysteresis/continuity advantage.

Intentions explicitly transition through:

```text
continue
suspend
complete
discard
```

This is sufficient to model persistent curiosity/projects while avoiding near-equal candidate ping-pong.

---

## 2.7 Action progression / interruption semantics are explicit — PASS

The architecture distinguishes:

```text
intention
!=
action step
```

Action interruption classes distinguish:

```text
immediate-safe interruption
checkpoint interruption
committed atomic consequence
```

This prevents causality-breaking rewinds after physical commitment.

A Luck-sensitive random choice must resolve before authoritative commitment and only among already-valid unresolved alternatives.

---

## 2.8 Immediate threat is separate from normal utility — PASS

Emergency flow is explicit:

```text
perceivable immediate threat
→ narrow defensive candidate set
→ rapid feasible response selection
→ authoritative action resolution
→ post-threat learning / normal reconsideration
```

No `+Infinity` / giant score hack or accumulating safety drive is required.

---

## 2.9 Learning mutation flow is explicit — PASS

Grounded evidence is decomposed into bounded owner-specific proposals:

```text
BeliefEvidence
AssociationImpact
HabitEvidence
EpisodeCandidate
PresenceEvidence
```

Sibling cognition stores do not mutate one another directly.

Same-outcome-chain learning may occur before reconsideration when the next decision semantically depends on that newly learned fact, as validated by `Scientific Method`.

---

## 2.10 Projects compose without becoming the brain — PASS

Canonical flow:

```text
ProjectOpportunity
→ ProjectContribution
→ normal CandidateIntention competition
→ SelectedIntention
→ ActionOutcome
→ ProjectProgressResult
```

Project state does not command Wilson and does not duplicate authoritative world physics.

Authored project form does not require pair-wise crafting rules; material/tool contributions should reuse property/capability interaction rules where practical.

---

## 2.11 Player influence remains indirect — PASS

Suggestions:

```text
SuggestionSignal
→ normal intention competition
```

Physical intervention:

```text
validated player-side affordance + God Power
→ world mutation
→ Wilson observation if perceivable
→ causal attribution
→ PresenceEvidence
```

Player private intent does not enter Wilson cognition.

Having enough God Power does not create an unsupported affordance. A supported intervention is not rejected merely because its grounded consequence may injure or kill Wilson.

---

## 2.12 Death, resurrection and run termination boundaries are explicit — PASS

Death resolves enough visible consequence for scene coherence, then offers:

```text
Resurrect
or
End Run
```

Resurrection is free and unlimited and preserves learned caution/negative association where appropriate without conscious death recall.

End Run permanently closes the active world and performs a player-side lifecycle transition rather than a persistence-adapter trick.

---

## 2.13 Cross-run Legacy ownership is explicit — PASS

Canonical boundary:

```text
current-run Wilson knowledge
→ filter legacy_eligible
→ player-profile weighted bounded selection
→ global Legacy Knowledge
→ next-run bootstrap projection
→ new Wilson knowledge owner
```

Legacy Knowledge is operational semantic knowledge only. It does not carry episodes, relationships, previous object instances, previous death facts or autobiographical source memories.

The player may clear this global progression.

---

## 2.14 Diary information classes are explicit — PASS

There is one player-facing Diary surface, but not one undifferentiated truth store.

```text
Wilson-grounded run narrative/history
→ cognition/history semantics

player lifetime statistics / run summaries / rare-event records / achievements
→ player-profile archive semantics

screenshot rendering/file bytes
→ presentation/storage adapter
```

UI co-location does not create shared mutation authority.

---

## 2.15 Luck is bounded and non-authoritative over causality — PASS

Preferred semantic model:

```text
neutral baseline
+ bounded active world/content modifiers
→ derived effective_luck
```

Luck may influence only explicitly luck-sensitive unresolved alternatives.

It cannot:

- legalize invalid actions;
- change Wilson's private decision score directly;
- create event eligibility;
- control rare-event frequency;
- reverse committed physics;
- rewrite a grounded outcome.

No separate persistent `chaoticity` state is required; ordinary pacing pressure remains bounded Director/opportunity logic.

---

## 2.16 Headless determinism/debuggability is preserved — PASS

The architecture can retain/reconstruct a causal trace linking:

```text
step/time
trigger batch
perception
expectation
candidates
contributions
seeded selection
intention
action
luck-sensitive random variant when applicable
outcome
observation
learning evidence
owner-local update
guard activation
```

Presentation randomness and optional LLM behavior need not alter authoritative gameplay RNG consumption.

---

## 2.17 Offline policy remains compatible — PASS

Offline catch-up reuses normal owners under conservative substitutions.

Current required exclusions remain compatible with the architecture:

```text
no offline Wilson death
no consumption of rare spectacle / major discovery by default
no opaque extreme relationship swing
no contradictory second behavioral model
```

---

# 3. What remains deliberately unresolved

The following are **implementation/calibration decisions**, not blockers to implementation design.

## 3.1 Concrete field/type representation

Still open:

- ID types;
- enum/tag/property/capability representation;
- semantic predicate/requirement representation;
- transformation rule representation;
- belief proposition and learned-interaction representation;
- typed value objects;
- collection/index structures;
- action/project identifiers;
- contract concrete type boundaries;
- player-profile / Legacy Knowledge representation;
- Diary archive record identity;
- Luck modifier/value-object representation.

## 3.2 Numeric formulas and calibration

Still open:

- drive curves;
- evaluator combination formula;
- exact bounded contribution ranges;
- confidence update formula;
- association/habit learning rates;
- hysteresis thresholds;
- maintenance/decay rates;
- actual clock frequencies;
- God Power generation/cost/cap values;
- Luck bounds/modifier composition and sensitive outcome classes;
- long-run dangerous-opportunity exposure ceiling;
- Legacy eligibility weights/selection count.

Implementation should expose these for deterministic testing/calibration rather than hardcode magic values throughout domain logic.

## 3.3 Persistence format/versioning

Still open:

- serialization technology;
- run save schema/versioning;
- global player-profile schema/versioning;
- migration strategy;
- exact mid-action resume representation;
- Diary screenshot/media retention strategy.

The semantic persistence boundary is already known.

## 3.4 Engine/application layout

Still open:

- exact Godot folder/node structure;
- domain language/runtime choice where not already fixed by project constraints;
- dependency-injection mechanism;
- concrete adapters;
- test harness organization;
- whether player intervention and player profile are separate aggregates/modules behind one player-domain facade.

These may now be designed from the responsibility graph rather than guessed from product prose.

## 3.5 First vertical-slice scope

The vertical slice should be chosen to exercise architecture contact points rather than maximize content.

A good first slice must cover at minimum:

```text
world truth
property/capability-driven physical interaction
perception
one drive
belief/expectation
candidate generation/evaluation
selected intention
action validation/outcome
learning
persistence/headless trace
presentation adapter boundary
```

It should also include at least one interruption/reconsideration case.

Legacy run termination, Diary archival breadth and Luck do not all need to be implemented in the very first headless slice, provided their domain boundaries are represented cleanly and subsequent slices can add them without breaking ownership.

---

# 4. Recommended implementation sequence

Proceed in this order.

## Step 1 — Concrete domain data model

Translate semantic state/contract requirements into minimal typed data structures.

Priority:

```text
stable IDs / semantic vocabulary
properties / capabilities / semantic role requirements
interaction eligibility + transformation rules
world query/result shapes
Wilson persistent stores/state + learned semantic interactions
intentional state
contracts: observation → decision → action → learning
minimal project/director state
player intervention + player-profile/Legacy boundary
Luck modifier/effective-value query boundary
Diary semantic record boundaries
trace identity / seeded RNG abstraction
```

Avoid adding fields solely because they are convenient to serialize or display.

## Step 2 — Package/module dependency layout

Make dependency direction enforceable:

```text
domain state/contracts
↑
pure domain services/evaluators
↑
application orchestration
↑
Godot/persistence/LLM/debug adapters
```

Prevent Godot scene objects from becoming domain identity/state owners.

Keep player-profile/global progression separable from active-run intervention even if both live under a broader player-domain package.

## Step 3 — Headless vertical slice first

Before visual polish, prove a deterministic headless loop that can:

1. advance time;
2. derive a physical exploration affordance from reusable properties/capabilities;
3. progress one action;
4. trigger reconsideration;
5. perceive bounded context;
6. generate/evaluate candidates;
7. select an intention with seeded RNG;
8. resolve a grounded property-driven outcome/transformation;
9. apply one belief/association/habit update path;
10. expose the learned semantic interaction after the observed result;
11. emit a complete decision trace;
12. save/load canonical state and reproduce behavior.

## Step 4 — Godot presentation adapter

Map the proven domain loop to presentation through semantic IDs/events.

Do not reimplement domain legality/decision logic in nodes/scripts.

## Step 5 — Regression scenes and lifecycle slices

Encode representative architecture regressions early:

```text
Scientific Method partial-feedback loop
Sabotaged Storage observation-vs-cause separation
Brilliant Shortcut deterministic risk trace
Falling Palm emergency fast path
```

Then add focused lifecycle regressions for:

```text
property-composed coconut opening with multiple valid tools
unknown exploration → learned semantic interaction
God Power unsupported-vs-supported affordance
lethal player intervention
unlimited resurrection with retained danger learning
End Run → weighted Legacy selection → new-run knowledge seed
single Diary surface with distinct Wilson/player record semantics
bounded Luck-sensitive variant selection
```

The first versions may be headless fixtures rather than full authored scenes.

---

# 5. Recommended first vertical slice

The strongest first slice remains a **small headless island micro-scenario centered on object experimentation and interruption**.

Suggested capabilities:

```text
Wilson with hunger + curiosity + risk_tolerance
2–4 world objects with semantic properties/capabilities
one food target
one uncertain tool/material interaction
at least two objects capable of satisfying one reusable interaction rule
one safe rest/idle option
one player suggestion signal
one environmental interruption/threat trigger
one simple persistent belief update
one simple association or habit update
seeded RNG + full decision trace
save/load
```

Why this slice:

- exercises the universal behavioral loop;
- proves the property/capability interaction model before a recipe catalog can leak into code;
- tests world truth vs Wilson belief;
- validates candidate composition;
- validates same-chain learning/reconsideration;
- validates interruption/hysteresis;
- can run entirely headless;
- does not require director/project/LLM/global-profile breadth immediately;
- leaves room to add player-presence, Luck and run-lifecycle verticals next without changing core boundaries.

Do **not** begin the first slice with `Sabotaged Storage` as the only scenario. It is an excellent integration regression but depends on more subsystems at once and would encourage premature implementation breadth.

---

# 6. Implementation constraints carried forward

The implementation phase must preserve these architecture invariants:

1. domain simulation runs without Godot rendering;
2. rendering FPS is not authoritative time;
3. all gameplay randomness is seeded/injected;
4. LLM paths are optional, bounded and non-authoritative;
5. world truth, observation, Wilson belief/knowledge and player knowledge remain distinct;
6. no system freely mutates another system's durable state;
7. transient salience/expectation/evaluation/effective-Luck values are recomputed rather than persisted by default;
8. generic physical/crafting interactions derive from properties/capabilities/context rather than an object-pair recipe catalog;
9. projects generate opportunities, not Wilson commands;
10. suggestions influence, never directly command Wilson;
11. God Power amount does not grant unsupported player affordances;
12. player private intent never becomes Wilson psychology;
13. immediate threat is a separate decision regime;
14. action commitment boundaries prevent causal rewinds;
15. Luck may bias only declared unresolved alternatives and never override causality;
16. resurrection remains free/unlimited and its long-term effects compose through normal learned state;
17. End Run is a domain lifecycle transition, not save-file deletion semantics;
18. Legacy Knowledge is player-global seed state, never shared mutable autobiographical memory;
19. the single Diary UI preserves separate Wilson-grounded and player-level truth classes;
20. decision traces remain semantically explainable;
21. guards use bounded contributions/saturation, not hidden normalization;
22. health monitoring is read-only by default;
23. adapters do not become domain owners.

---

# 7. Gate conclusion

**Architecture gate: PASS after final gameplay-design regression.**

Wilson Shipwrecked is ready to enter **concrete domain-model + implementation-layout design**.

No additional broad discovery phase is recommended before that work.

Future implementation evidence may still invalidate an individual contract. If that happens, follow the architectural change protocol in `AGENTS.md`: identify the failed invariant/scene, update the canonical design document and regression tests, and avoid creating a silent parallel architecture.
