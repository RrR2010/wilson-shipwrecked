# Canonical Domain Micro-Loop

## Status and purpose

This document is the canonical language-neutral micro-orchestration companion to:

- `DOMAIN_MODEL.md`;
- `DOMAIN_OPERATIONS.md`;
- `DOMAIN_PROCEDURAL_COMPOSITION.md`;
- `SIMULATION_ORCHESTRATION.md`.

It explains semantic **frame groups**, tactical versus intentional cadence, same-chain learning and the Scientific Method regression. It does not override the operation surface: accepted public operation semantics live in `DOMAIN_OPERATIONS.md`.

A frame group is not a rendered frame. It is a bounded interval during which the active action/intention semantics remain stable until a meaningful boundary occurs.

---

# 1. Why a micro-loop exists

The macro orchestrator answers:

> In what deterministic order do owners/services run?

The micro-loop answers:

> What makes Wilson continue, refine a tactic, learn, reconsider the objective or branch at a semantic boundary?

Representative scenes must emerge from reusable semantics, not hidden scene scripts:

```text
persistent intention
+ bounded local action grammar
+ imperfect Wilson-relative claims
+ grounded physical outcomes
+ immediate accessible evidence/learning
+ tactical reconsideration
+ occasional intentional reconsideration
```

---

# 2. FrameGroup

Conceptual trace type:

```text
FrameGroup
  id
  entry snapshot/provenance
  active intention?
  active action execution?
  due authoritative progression
  committed results/events[]
  derived invalidation summary?
  perception result?
  immediate learning summary?
  trigger batch[]
  routed decision scope?
  selected tactic/intention?
  exit reason
```

It is trace/orchestration evidence, not required durable gameplay state.

A frame group ends on a meaningful boundary such as:

```text
action completion/interruption/commit
action invalidation
meaningful WorldEvent
new accessible evidence
prediction error/anomaly
immediate perceived threat
drive urgency-band transition
major player/Director signal
project checkpoint
intention completion
```

Rendering may produce any number of frames inside one frame group.

---

# 3. Cadence and decision scopes

```text
PHYSICAL_PROGRESSION
TACTICAL_RECONSIDERATION
INTENTIONAL_RECONSIDERATION
```

Immediate threat is a separate fast-path regime.

## Physical progression

Answers what happens while an already-started action/process progresses. It may cross authoritative commit boundaries without globally reconsidering Wilson.

## Tactical reconsideration

Answers:

> Given the current intention and newly learned/perceived evidence, what should Wilson try next?

Candidate space stays local to the current objective.

## Intentional reconsideration

Answers:

> Is the current intention still worth pursuing compared with broader needs/projects/opportunities?

Do not run broad competition after every ordinary failed tactic.

---

# 4. Truth, attemptability, resolution and believed opportunity

These layers remain distinct.

## ActionAttemptability

Authoritative physical derivation:

```text
QueryActionAttemptability(action_id, role_binding, PhysicalRuleContext)
→ AttemptabilityResult
```

It asks whether Wilson can initiate/perform the attempt far enough to obtain a grounded consequence/evidence. Hidden resistance normally does not erase an enactable experiment.

Examples:

```text
pull a sealed lid that will not move
hit a resistant target with a weak stick
try lifting an object that proves too heavy
```

## Resolution applicability

Once an attempt progresses/commits, authoritative resolution uses complete physical truth:

```text
attemptable action
+ EffectivePhysicalProfile
+ relations/context
→ ActionOutcome
```

A result may be success, partial progress, no effect, blocked-after-attempt semantics or failure. Public classification may represent those distinctions through the normal outcome + diagnostic contracts rather than multiplying enums unnecessarily.

## PerceivedTacticalOpportunity

Wilson-relative derivation uses only accessible/perceived/believed semantics.

Valid states include:

```text
attemptable + Wilson expects success
attemptable + Wilson uncertain
attemptable + Wilson expects failure but tests for information
physically ineffective + Wilson expects success
physically effective + Wilson has not discovered the tactic
```

This separation is essential for experimentation.

---

# 5. EffectivePhysicalProfile inside the loop

Effective physical resolution remains deterministic, acyclic and traceable.

Conceptual precedence/input layers:

```text
material/default authored semantics
→ entity definition
→ instance overrides/condition
→ validated assembly/component inputs
→ admitted contents aggregation
→ derived capability/affordance rules
```

`PropertyDerivationDefinition` uses bounded selectors and registered policies; no arbitrary callbacks.

Current proven selector forms:

```text
self.property
assembly_slot(slot_id).property
```

A component property change may invalidate a host profile through `CompositionDependencyProjection`; gameplay code must not scatter manual host invalidation.

### Structural constraint

Recursive composition/aggregation must reject cycles. Relation storage identity does **not** enforce semantic slot exclusivity: if a component/configuration must not occupy certain roles simultaneously, that constraint belongs to explicit assembly/relation validation.

---

# 6. Perception, evidence and typed claims

Conceptually:

```text
WorldEvent/current World truth
→ PerceptionAccess
→ PerceptionResult
   ├─ perceived subjects
   ├─ ObservedEvent[]
   └─ PerceptualEvidence[]
```

`PerceptualEvidence` carries a typed Wilson-relative claim plus confidence/provenance:

```text
PROPERTY(subject, PropertyId, PropertyValue)
RELATION(subject, RelationTypeId, object)
EVENT(subject, EventDefinitionId, perceived_role)
```

Only accessible roles/semantics become evidence. Hidden authoritative bindings/cause do not leak through the claim.

Static properties/relations do not require fabricated WorldEvents; inspect/touch/lift/shake/etc. may later use bounded `EvidenceRuleDefinition`s to emit property/relation claims directly.

Evidence quality may remain coarse/uncertain. Observation is not exact truth merely because it is accessible.

---

# 7. Same-chain learning order

For experimentation the normative order is:

```text
committed ActionExecution boundary
→ ActionOutcome
→ World owner mutation
→ SemanticChangeSet invalidation
→ WorldEvent
→ PerceptionAccess / PerceptionResult
→ immediate relevant owner-specific learning proposals
→ bounded cognition mutations
→ derive tactical opportunities from revised cognition
→ tactical selection
```

This order is required when evidence from one attempt can materially alter the next tactic.

Maintenance-only learning may remain deferred.

---

# 8. Information-seeking tactics

Candidate evaluation may value information as well as material progress.

Bounded contributions may include:

```text
expected goal progress
expected information gain
hypothesis discrimination
cost/effort
perceived risk
continuity
novelty/curiosity
repetition penalty
partial-progress leverage
```

Information value derives from uncertainty + available evidence modalities; it is not a persisted exploration percentage.

This supports:

```text
inspect before hitting
shake before opening
try a materially different tool after failure
inspect a newly dented region
```

without scripts.

---

# 9. Repetition without universal failure counters

Do not persist a generic:

```text
failed_attempt_count(object, action)
```

Ordinary repetition control derives from bounded same-chain history + beliefs/outcomes.

Conceptual `DecisionContinuationContext` may contain:

```text
intention id
recent tactic signatures[]
recent outcome/evidence refs[]
last meaningful progress?
```

It is bounded continuation context, not autobiographical memory.

---

# 10. InteractionRegion

The Scientific Method fixture justifies a bounded semantic sub-target concept:

```text
InteractionRegionDefinition
  id
  host applicability
  semantic categories/accepted action roles
  optional admitted local physical modifiers

InteractionRegionRef(host, region_id)
```

Examples:

```text
lid_edge
handle
weak_joint
dented_region
rope_knot
shelter_repair_point
tool_grip
fruit_cluster
```

Rules:

- semantic bounded sub-target, not arbitrary mesh triangles;
- no independent World entity unless it has independent lifecycle/relations;
- presentation maps region IDs to anchors/colliders/transforms;
- Wilson can intentionally target hidden weakness only after relevant perception/discovery, unless the action is broad/exploratory.

The structural runtime has not yet required a concrete InteractionRegion implementation; this remains an admitted future adapter/domain contract rather than unfinished foundation ownership.

---

# 11. Scientific Method regression — representative causal path

The following path is evidence, not a mandatory script.

## FG0 — notice unfamiliar container

Perception exposes coarse visible semantics only. Novelty/stimulation may make `investigate(container)` win intentional competition.

## FG1 — inspect

Visual inspection produces accessible evidence such as coarse material appearance/lid boundary. It does not expose hidden exact hardness, closure resistance or contents.

Learning updates relevant typed claims before the next tactic.

## FG2 — first pull

The lid is reachable/grippable, therefore pull is attemptable even if hidden closure resistance is high.

Grounded result may be:

```text
NO_EFFECT
+ lid did not move / exertion applied diagnostic
```

Wilson learns that this ordinary pull was ineffective on this instance.

Route normally stays tactical.

## FG3 — variation / stronger pull

Wilson may change angle/force/technique. Repeated failure reduces expected value through recent outcome/belief evidence rather than a universal failure counter.

Escalate to intentional only if broader conditions justify it: no local tactics, urgent drive, major event, risk/cost change, etc.

## FG4 — alternative material/tool

A nearby wood component/tool may become relevant because Wilson needs another way to affect the closure. World may know it is weak; Wilson does not.

## FG5 — wood strike

The strike is physically attemptable. Resolution may damage/break the wood before affecting the target.

Accessible evidence supports:

```text
this wood/tool unsuitable for this high-impact use
```

with any category generalization weaker/bounded.

A stone can become more salient from revised cognition without any World mutation.

## FG6 — stone tactic

Wilson's prior/perceived beliefs can make stone-mediated impact plausible; authoritative stone properties remain hidden until evidence supports them.

## FG7 — partial impact

Example:

```text
container/lid deforms
closure remains engaged
→ PARTIAL / dented semantic outcome
```

Immediate evidence increases support that this tactic materially affects the target. Useful partial progress protects intention continuity.

## FG8 — local refinement

Candidate variants may include same spot, dented edge, new angle, more force or inspect-first. This is tactical, not a global replan.

`InteractionRegion` allows a bounded semantic target such as `dented_region` without triangle-level planning.

## FG9 — opening consequence

A later committed strike may satisfy the physical conditions for opening.

World mutation may set/remove the relevant property/relation and move/detach a lid. Any relation removal uses exact qualified identity where a qualifier is part of the authoritative relation.

Committed consequences resolve before reconsideration.

## FG10 — reveal

Once configuration changes make contents accessible, perception can produce new subject/relation/property evidence. No discovery lottery follows sufficient grounded evidence.

## FG11 — intention completion

If the objective was to open the container, completion now justifies intentional reconsideration for what comes next.

---

# 12. Branches that must remain possible

The fixture is valid only if reusable semantics permit variants such as:

- weaker target/stronger wood opens early;
- hunger/storm/project signal suspends the investigation at a safe causal boundary;
- Wilson makes a wrong inference that later contradiction can revise;
- hidden contents are damaged before Wilson can observe that fact;
- transparent versus opaque container changes evidence accessibility without a second cognition architecture;
- the same physical sequence can produce different later decisions because Wilson history/beliefs differ.

---

# 13. Trigger routing defaults

| Semantic boundary | Default scope |
|---|---|
| ordinary progress/checkpoint | none / continue |
| action completes, intention unresolved | TACTICAL |
| useful partial progress | TACTICAL |
| ordinary failed tactic with alternatives | TACTICAL |
| new current-intention evidence | TACTICAL |
| no plausible local tactics | INTENTIONAL |
| intention completes/impossible | INTENTIONAL |
| urgent drive-band transition | INTENTIONAL |
| major external opportunity/signal | INTENTIONAL at admitted boundary |
| immediate perceived threat | IMMEDIATE_THREAT |

Triggers in one boundary are coalesced. The strongest required scope wins, but committed physical consequences always resolve first.

---

# 14. Trace/debug requirements

A deterministic headless trace should answer:

```text
What was authoritative truth?
Which derived physical properties came from which inputs?
What was attemptable and why?
What could Wilson perceive?
Which typed claim/evidence was produced?
Which belief changed and why?
Why did a tactic remain plausible or lose support?
Why did routing stay tactical or escalate?
Which stable ordering/RNG stream selected among alternatives?
```

If the explanation requires `scene.scientific_method`, hidden omniscient cognition or an object-pair recipe, the regression fails.

---

# 15. Micro-loop gate

The Scientific Method contract passes when:

- hidden truth can make an attempt fail without preventing learning-capable enactment;
- Wilson never receives hidden physical properties/cause directly;
- evidence is accessibility/modality constrained;
- relevant learning is available before the next same-chain tactic;
- tactical scope persists while the intention remains coherent;
- effective physical semantics derive deterministically from typed causes/composition;
- composition is cycle-safe and dependent cache invalidation is explicit;
- semantic sub-targets can be introduced without general mesh reasoning;
- partial outcomes affect future tactic evaluation;
- broad intentional competition is not run after every physical step;
- variation can shorten/suspend/redirect the path without bypass logic;
- no recipe catalogue, exploration percentage, scene state machine or omniscient candidate generation is required.

**Result: PASS.**
