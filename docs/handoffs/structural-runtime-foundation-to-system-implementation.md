# Handoff — Structural Runtime Foundation → System Implementation

## Purpose

This handoff transfers Wilson Shipwrecked from the completed **structural runtime foundation** phase into the next phase: implementing broader gameplay systems on top of the validated domain/runtime contracts.

This document is operational transition context. It is **not** a new canonical design authority.

When this handoff and a canonical document appear to disagree, the canonical document wins. Use [`../README.md`](../README.md) for the documentation authority map and [`../DISCOVERY_STATUS.md`](../DISCOVERY_STATUS.md) for the current validated implementation status.

---

# 1. Current phase

The project has completed three major gates:

```text
FUNCTIONAL DOMAIN               COMPLETE
STRUCTURAL RUNTIME FOUNDATION   COMPLETE
DOCUMENTATION CONSOLIDATION     COMPLETE
```

The next phase should therefore be treated as:

```text
SYSTEM IMPLEMENTATION / GAMEPLAY BREADTH
```

The task is **not** to redesign the domain model, create a second architecture, or replace the existing vertical foundation with a simplified parallel stack.

The task is to implement missing gameplay systems using the established semantic contracts.

The strict Godot 4.7.1 headless suite is currently validated at:

```text
PASS headless_suite (23 tests)
```

That checkpoint is the baseline. New work should preserve it and extend it with focused regressions.

---

# 2. Required reading

Read the smallest useful bundle before changing code.

## Always read first

```text
AGENTS.md
README.md
docs/README.md
docs/DISCOVERY_STATUS.md
```

## For simulation/system implementation

```text
docs/ARCHITECTURE.md
docs/SIMULATION_CONTRACTS.md
docs/SIMULATION_ORCHESTRATION.md
docs/MUTATION_AUTHORITY.md
docs/DOMAIN_MODEL.md
docs/DOMAIN_VOCABULARY.md
docs/DOMAIN_CATALOGS.md
docs/DOMAIN_OPERATIONS.md
```

Then add specialized documents only when the implementation touches them:

```text
docs/DOMAIN_PROCEDURAL_COMPOSITION.md
docs/DOMAIN_ENVIRONMENTAL_PROTECTION.md
docs/DOMAIN_HAZARD_DYNAMICS.md
docs/DOMAIN_EPISTEMIC_INVESTIGATION.md
docs/DOMAIN_MICRO_LOOP.md
docs/GUARDS_AND_CALIBRATION.md
docs/STATE_REQUIREMENTS.md
```

Fixtures/regressions are evidence and executable-behavior references, not competing architecture.

---

# 3. Foundation that is already closed

Do not reopen these decisions merely because another implementation shape is locally convenient.

## 3.1 Authority boundaries

Canonical owner families remain:

```text
World
Wilson Cognition
Projects
Director
Player Run State / Intervention
Action Execution / Resolution
Player Profile across runs
```

Derived services/indexes/projections are not new authorities.

Core invariant:

```text
state owner
!= derived service
!= graph/index
!= orchestration
!= presentation
```

## 3.2 Epistemic separation

Never collapse:

```text
world truth
!= Wilson observation
!= Wilson belief
!= player private intent
```

Wilson cognition must consume perceptual/evidence contracts, not hidden authoritative World state.

Private player intent must never directly alter Wilson trust, presence belief, dependency, beliefs, memories, or causal attribution.

## 3.3 Definition/state separation

Keep authored immutable definitions distinct from runtime authority.

Examples:

```text
EntityDefinition       != EntityInstance
ActionDefinition       != ActionExecutionState
DirectedEventDefinition != DirectedEventInstance
PropertyDefinition     != property override
AssemblyDefinition     != World assembly bindings
```

Content bootstrap validates authored semantics before runtime use.

## 3.4 World read/write boundary

Preserve:

```text
WorldState / owner stores = authoritative data
WorldQuery               = narrow semantic reads
WorldCommands            = validated owner-local mutations
```

Do not pass unrestricted stores into services that only need a query.

Do not mutate authoritative World state from presentation, cognition, projects, Director, or arbitrary callbacks.

## 3.5 Explicit causal mutation chain

The validated causal direction is:

```text
ActionExecution
→ ActionOutcome
→ validated World command/commit
→ WorldEvent + SemanticChangeSet
→ derived invalidation
→ Perception
→ PerceptualEvidence
→ owner-local learning
→ decision/reconsideration
```

No broad event bus may define authoritative mutation order.

## 3.6 Committed actions do not rewind

Action execution has an explicit pre/post-commit boundary.

Once committed physical consequence exists:

```text
reconsideration
player suggestion
Luck
save/load
```

must not rewind it or duplicate its outcome.

Persistence reconstruction must restore causal execution state rather than rerunning attemptability for already-started actions.

## 3.7 Action interruption semantics

Concrete runtime interruption classes are already established:

```text
PRE_COMMIT_ONLY
NEVER
ANYTIME
```

Do not reintroduce an ambiguous universal `interruptible: bool`.

## 3.8 Property semantics

Properties are validated through typed `PropertyDefinition` schemas and bounded property-value families.

Ordered comparisons are allowed only for compatible ordered families.

Invalid values/bounds must fail before authoritative mutation and must not emit a WorldEvent/SemanticChange.

Do not return to unrestricted `Variant` semantics at public domain boundaries merely for convenience.

## 3.9 Relations

World relations are authoritative and indexed through reconstructible views.

Relation identity includes its semantic qualifier where the qualifier distinguishes the relationship.

Assembly slot identity is therefore part of the exact qualified relation semantics.

Do not restore an API that means only:

```text
remove(type, subject, object)
```

when multiple qualified relations may exist between the same pair.

## 3.10 Graphs and indexes

Validated derived graph/projection families include:

```text
World relation indexes
PropertyDependencyGraph
AssemblyBindingProjection
CompositionDependencyProjection
EpistemicGraphProjection
bounded SemanticPattern matching
```

Invariant:

```text
graph/index/projection != authority owner
```

Persist causes; rebuild derived structures.

## 3.11 Composition

Composite physical truth remains normal World entities/relations.

There is intentionally no universal `AssemblyStore` or `CraftingSystem` authority.

Validated semantics include:

```text
AssemblyValidity
!= effective performance
```

A valid assembly may degrade in `impact_capacity`, `stability`, etc. while remaining structurally `VALID`.

Property derivation may consume bounded semantic assembly-slot selectors.

Component property changes propagate invalidation through `CompositionDependencyProjection` to dependent hosts.

## 3.12 Epistemic claim model

Persistent/semantic epistemic identity is a closed typed family:

```text
EpistemicClaim.PROPERTY
EpistemicClaim.RELATION
EpistemicClaim.EVENT
```

Do not replace it with a generic durable:

```text
predicate: StringName
arguments: Variant[]
```

Causal hypotheses used during investigation remain transient derived interpretations unless a concrete durable requirement proves a new claim family necessary.

## 3.13 Event terminology

Use these names consistently:

```text
EventDefinition
  authored semantic definition of a WorldEvent kind

WorldEvent
  authoritative occurrence fact

ObservedEvent
  Wilson-accessible projection

DirectedEventDefinition / DirectedEventInstance
  Director-owned opportunity lifecycle
```

Do not call Director content simply `EventDefinition` in new APIs.

## 3.14 Spatial boundary

Spatial/navigation representation remains an infrastructure choice.

Domain/application code should consume narrow spatial/perception query contracts rather than Godot scene-tree geometry.

Godot nodes, scene paths, colliders, navmesh IDs, sockets, and meshes are adapters, not domain identity.

## 3.15 Optional LLM boundary

The core simulation must remain complete and deterministic with runtime AI disabled or unavailable.

LLM output may only provide bounded interpretation/reweighting/expression among already valid semantics.

It may not invent authoritative World facts, memories, physical properties, action legality, or outcomes.

---

# 4. What the existing runtime foundation proves

The 23-test baseline establishes concrete behavior across the foundational vertical.

The validated implementation includes coverage for these categories:

```text
typed IDs / runtime references
immutable content/bootstrap validation
typed property schemas and runtime mutation validation
World entities and qualified relations
reconstructible relation indexes
property dependency DAG and effective physical profile
assembly binding projection and AssemblyValidity
component-aware composition derivation
composition-dependent cache invalidation
bounded SemanticPattern / action attemptability
committed action execution
pre/post-commit persistence reconstruction
action interruption lifecycle
semantic snapshot immutability
SemanticChangeSet invalidation
EventDefinitionId → WorldEvent → observation/evidence identity
perception access filtering
typed EpistemicClaim learning
BeliefStore and EpistemicGraphProjection
decision routing / current intention
application micro-loop orchestration
semantic trace
JSON snapshot / restore / rebuild
strict headless runner behavior
```

Before extending any of these areas, inspect the existing code/tests and reuse the established primitive rather than creating an alternative abstraction.

---

# 5. Recommended next implementation sequence

The exact order may change when concrete dependencies justify it, but the default sequence should be:

```text
1. concrete spatial query + perception-access adapter
2. Wilson drive / project / habit candidate producers
3. broader action lifecycle + interruption/checkpoint behavior
4. projects and grounded contribution lifecycle
5. world environment / dynamic processes / hazards
6. shallow non-Wilson actor behavior
7. player intervention + suggestion flows
8. Director opportunity lifecycle
9. broader persistence/lifecycle coverage
10. presentation/Godot adapters
11. representative scene rendering/integration regressions
12. larger deterministic simulation health runs
```

Do not attempt all systems at once. Prefer vertical slices that add one meaningful behavior while reusing the existing chain end-to-end.

---

# 6. First recommended vertical: spatial/perception integration

This is the strongest next foundation extension because many higher systems need a real bounded local context.

## Objective

Replace fixture-only/manual perception accessibility with a concrete adapter that answers questions such as:

```text
what subjects are locally perceivable?
what is visible/audible/otherwise accessible?
what semantic interaction region is reachable?
what route or nearby candidate set is available?
```

without leaking Godot implementation into domain logic.

## Expected shape

Keep conceptual separation:

```text
Godot / nav / geometry
        ↓ adapter
SpatialQuery / PerceptionAccess ports
        ↓
application/domain services
```

Do not put `Node3D`, `RID`, collider references, scene paths, or navmesh object identity into domain records.

## Suggested regression

A headless fixture should prove at least:

```text
same authoritative World
+ different access/occlusion projection
→ different ObservedEvent / PerceptualEvidence
→ different Wilson belief update

hidden world fact remains unavailable to cognition
```

This would strengthen Scientific Method, Missing Spoon, Sabotaged Storage, hazard perception, and future presentation integration simultaneously.

---

# 7. Candidate-source implementation

After a real local/perceived context exists, implement candidate producers incrementally.

Candidate generation should remain compositional:

```text
Drive source
Project source
Habit source
Known-interaction source
Exploration source
Suspended-interest source
Suggestion source
Director-opportunity source
Reaction source
```

Each source proposes semantic candidates. It does not mutate current intention.

Candidates should deduplicate semantically so multiple reasons can support one candidate without creating duplicate lottery entries.

All scoring/evaluation contributions must be finite, bounded, and explainable.

Immediate threat remains a separate decision regime; do not emulate emergency with huge scores.

### First useful candidate regression

Prove something like:

```text
hunger meaningful
+ edible perceived subject
+ unfinished low-urgency project
→ both candidates exist
→ bounded contributions are traceable
→ selected intention depends on state/seed
→ neither source commits cognition directly
```

Then add project/habit/suggestion contributions separately.

---

# 8. Projects

Project physical truth remains World-owned.

A project implementation should own only:

```text
project identity
lifecycle
semantic bindings
bounded project metadata not already represented physically
```

Expected flow:

```text
ProjectDefinition / ProjectInstance
→ contribution opportunity
→ candidate intention
→ normal action
→ World commit
→ grounded ActionOutcome
→ project owner validates contribution
→ project lifecycle/progress mutation
```

Do not reserve arbitrary world resources globally because a project might use them.

Do not duplicate component integrity, roof condition, assembly bindings, or contents in project state.

A good first project vertical is one simple shelter contribution using existing entities/relations rather than a bespoke building subsystem.

---

# 9. Broader action lifecycle

The foundation already proves committed/non-rewind behavior and interruption classes.

Next work should broaden lifecycle semantics without weakening those guarantees.

Useful additions include:

```text
checkpoint-oriented actions
multi-step contribution actions
action invalidation between checkpoints
post-commit tails
terminal execution pruning/maintenance
bounded retry/reconsideration behavior
```

Tests should distinguish:

```text
pre-commit interruption
post-commit consequence
ANYTIME post-commit interruption of remaining tail
NEVER action rejection of interruption
save/load around each boundary
```

Do not make animation completion authoritative action success.

---

# 10. Environment, hazards and dynamic processes

Use the existing specialized contracts instead of building scene scripts.

Preferred flow:

```text
World process state
→ deterministic advance
→ authoritative mutation/event
→ HazardProjection or ExposureResult where relevant
→ Perception
→ PerceivedThreat
→ immediate-threat decision path
```

Critical invariant:

```text
committed environmental process
!= predetermined collision victim/outcome
```

Falling Palm exists specifically to protect this distinction.

Environmental effects should normally mutate ordinary physical properties/processes, e.g. moisture, structural integrity, temperature, rather than secretly changing effective profiles through global context hooks.

Offline policies must remain conservative:

```text
no death offline
no consumption of rare spectacle/discovery opportunities
no opaque extreme relationship changes
```

---

# 11. Shallow non-Wilson actors

Animals should remain materially simpler than Wilson unless representative behavior proves otherwise.

Target shape:

```text
persistent EntityId where narratively important
+ ActorProfileDefinition
+ shallow current activity/target
+ deterministic bounded behavior rules
```

Do not introduce a second Wilson-level cognition architecture for animals.

Gerald-style relationships live primarily in Wilson's beliefs/associations/habits about Gerald, not in a deep Gerald psychology model.

---

# 12. Player intervention and suggestions

Keep physical intervention and suggestion semantically distinct.

Physical intervention:

```text
player request
→ player permission/cost validation
→ World command path
→ WorldEvent
→ perception
→ Wilson attribution/learning only when observable/inferable
```

Suggestion:

```text
SuggestionSignal
→ bounded candidate/evaluation contribution
→ normal competition
→ normal action validation
```

A suggestion never forces the selected intention.

A beneficial intervention does not automatically increase trust merely because the player intended to help.

---

# 13. Director

The Director controls opportunity lifecycle, rarity/cooldown, and bounded framing.

It does not control Wilson.

Expected flow:

```text
DirectorContext
→ DirectedEvent eligibility
→ temporary opportunity / world manifestation / bounded bias
→ perception + ordinary candidate generation
→ Wilson chooses normally
```

Do not implement authored scene scripts that directly select Wilson's next action/intention.

---

# 14. Persistence rules for new systems

Always ask whether data is a durable cause or a reconstructible projection.

Persist when required for continuity:

```text
authoritative owner state
active committed process state needed for coherent continuation
meaningful current/suspended intention
project/director/player lifecycle state
required deterministic RNG state
```

Normally rebuild:

```text
graph indexes
candidate lists
salience
expectations
AssemblyValidity
EffectivePhysicalProfile
CompositionDependencyProjection
EpistemicGraphProjection
HazardProjection
ProtectionProjection
routes
perception snapshots
most transient reactions
```

Save/load regressions should query semantics after reconstruction, not merely compare raw JSON.

---

# 15. Presentation phase boundary

Presentation work may now start incrementally, but it must adapt to the simulation rather than define it.

Godot should consume:

```text
authoritative snapshots
semantic action state
WorldEvent / presentation projection
reaction/speech semantic intents
interaction anchors/regions
```

Presentation may realize:

```text
meshes
animation
VFX/audio
camera
UI
navigation geometry
semantic anchors/sockets
```

but these must not become domain identity or legality rules.

The cross-cutting content source of truth is [`../asset-catalog/README.md`](../asset-catalog/README.md), not `docs/art/` object lists.

---

# 16. Testing workflow

The strict external runner is part of the foundation contract.

Run:

```powershell
.\tests\run_headless_tests.ps1
```

The runner executes each `tests/headless/*_test.gd` independently and rejects false-green Godot runs, including:

```text
SCRIPT ERROR
parse/compile failures
generic engine ERROR:
explicit FAIL
missing expected PASS
non-zero process exit
```

Do not replace this with a looser runner.

For each new system slice:

```text
small pure/domain tests where useful
+ one focused integration regression
+ full strict suite
```

Prefer deterministic semantic assertions over rendered output assertions for domain behavior.

Presentation itself can add separate scene/rendering tests later.

---

# 17. Implementation discipline

Use these rules while extending the system:

```text
one semantic question per service where practical
narrow query ports
explicit result objects with diagnostics/provenance
owner-local mutation only
seeded gameplay RNG
stable ordering before stochastic choice
no arbitrary authored callbacks
no unbounded graph/world Cartesian scans
no scene-specific state machines when reusable semantics suffice
no generic Dictionary/Variant public model as a shortcut
```

When a new primitive seems necessary, first try:

```text
existing property
existing capability
existing category
existing relation
existing RequirementPredicate
existing SemanticPattern
existing EpistemicClaim
existing ActionDefinition
existing Effect
existing owner state
existing derived projection
```

Only add a primitive if a concrete invariant or representative behavior cannot be expressed cleanly with existing composition.

---

# 18. Known implementation questions — not architecture blockers

The remaining questions are primarily concrete system/content choices:

```text
exact spatial topology/navigation representation
body mutation proposer API
shallow animal behavior details
dynamic-process persistence thresholds
exact SemanticConceptId expansion boundaries
authored-content serialization/loading format beyond current validated bootstrap
presentation adapters for InteractionRegion / anchors / assembly sockets / body slots
deterministic simultaneous-boundary tie-break policy at larger scale
coarse protection coverage/gap representation
full candidate producer set
action checkpoint taxonomy beyond current interruption classes
richer authored-base vs runtime-override provenance
broader negative-evidence ObservationCoverage implementation
larger content/persistence migrations across authored-content version changes
```

Treat these as implementation decisions to resolve with focused evidence, not invitations to redesign the state-owner architecture.

---

# 19. Explicit anti-decisions

Do not introduce by default:

```text
EverythingGraph / universal triple store
AssemblyStore as a new physical authority
CraftingSystem with object-pair recipes
Giant WilsonBrain
one mutable System per psychology noun
universal GOAP planner
one global utility god-function
infinite / huge sentinel scores
persistent salience/candidate caches as truth
full psychology for every animal
Godot nodes as domain entities
UI-side action legality rules
broad event bus controlling mutation order
LLM-dependent core gameplay
player-private-intent → Wilson cognition shortcut
generic durable predicate+arguments epistemic schema
scene-specific progression scripts for representative scenes
```

If a future case genuinely requires changing one of these anti-decisions, update the owning canonical document and its regressions explicitly.

---

# 20. Acceptance gates for the next phase

A new system slice is acceptable when all applicable statements are true:

```text
existing 23-test baseline remains green
new behavior is covered by deterministic regression
owner/mutation authority remains explicit
world/observation/belief separation is preserved
new derived data is reconstructible rather than accidentally persisted
new randomness is seeded and traceable
new candidate influences are bounded/explainable
no scene-specific or entity-type branching replaces reusable semantics
save/load reconstruction preserves tested semantics when the slice is durable
Godot/presentation details remain outside domain authority
canonical docs are updated only when the semantic contract actually changes
DISCOVERY_STATUS is updated when a meaningful gate closes
```

Do not update status merely because scaffolding exists. Close a gate only after the strict suite proves the relevant behavior.

---

# 21. Suggested working pattern for the next agent

For each implementation block:

```text
1. identify one player-visible/systemic behavior
2. map it to existing canonical contracts
3. inspect existing runtime primitives/tests
4. add the smallest missing reusable primitive/service
5. write focused deterministic regression
6. integrate through the existing application causal chain
7. run strict headless suite
8. update owning canonical docs only if semantics changed
9. update DISCOVERY_STATUS only when the gate is actually closed
```

Avoid large speculative subsystem scaffolds with no executable behavioral proof.

---

# 22. Recommended first task

Unless current product priorities dictate otherwise, start with:

> **Concrete spatial query + perception-access integration**

Success criteria:

```text
bounded local subject discovery
+ accessibility/occlusion projection
+ no hidden World leakage into cognition
+ deterministic headless regression
+ no Godot identity in domain records
```

Then build candidate-source breadth on top of that real perceived local context.

---

# 23. Final handoff state

The project no longer needs another architecture-discovery pass before implementation.

The stable direction is:

```text
canonical product/domain contracts
        ↓
validated structural runtime foundation
        ↓
focused system verticals
        ↓
content breadth
        ↓
presentation integration
        ↓
large deterministic behavioral regressions
```

The next agent should optimize for **systemic breadth without semantic regression**.

The main risk is no longer lack of architecture. It is accidentally bypassing the architecture while implementing concrete features.