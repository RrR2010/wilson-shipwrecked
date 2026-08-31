# Discovery Status

## Current phase

Product/behavior discovery, architecture contracts and the language-neutral functional-domain stabilization are complete enough to proceed.

The current engineering/design phase is:

```text
package/module dependency layout
→ concrete domain types
→ declarative content fixtures
→ first vertical slice
→ deterministic regression execution
→ presentation adapters
```

In parallel, the cross-cutting [`asset-catalog/`](asset-catalog/) can be enriched from an art-seeded model-production catalog into a fuller **functional + visual content catalog**, provided catalog rows continue to reference rather than redefine canonical domain semantics.

For documentation navigation and authority, use [`README.md`](README.md). This file intentionally contains status only.

---

# Closed gates

Current status:

```text
Product / behavioral discovery           PASS
Architecture responsibility boundaries   PASS
Simulation contracts / orchestration     PASS
Mutation authority                       PASS
Guards / bounded calibration             PASS

Structural functional domain             PASS
Vocabulary normalization                 PASS
Representative-scene regression          PASS
Operation regression                     PASS
Functional asset breadth                 PASS
Gradual exploration / evidence            PASS
Composite-object semantics               PASS
Environmental protection / exposure      PASS
Scientific Method micro-loop             PASS
Falling Palm hazard micro-loop           PASS
Sabotaged Storage epistemic micro-loop   PASS
Improvised hammer fixture                PASS
Cloth/shelter/weather fixture            PASS
```

**Functional-domain stabilization gate: PASS.**

The validated model did not require separate state-owning systems for crafting, tool quality, shelter, exploration, tactical planning, hazard projection or suspicion/investigation. Those concerns remain compositions, projections or bounded working contexts inside existing authority boundaries.

---

# Stabilized architectural shape

State-owning families remain:

```text
World Simulation
Wilson Cognition
Projects
Player Run State / Intervention
Director
Action Execution / Resolution
Player Profile across runs
```

Important derived/non-owning concerns include:

```text
Perception / PerceptualEvidence
Expectation / salience
EffectivePhysicalProfile / AssemblyValidity
Protection / exposure
Affordance / ActionAttemptability
Tactical and intentional decision projections
HazardProjection / PerceivedThreat
Bounded investigation / causal attribution
Learning proposals / reaction
Luck
```

Rendering remains non-authoritative. Wilson knowledge remains distinct from world truth, and player-private intent remains distinct from Wilson causal attribution.

---

# Current content/catalog state

The repository now has a deliberate ownership split:

```text
docs/asset-catalog/
  cross-cutting modeled-content requirements + production backlog

docs/art/
  visual language, references and artistic production process

docs/brainstorming/functional-asset-catalog/
  historical breadth exploration / upstream evidence
```

The asset catalog is correctly outside `art/`. Its current tables are functional/artistic seeds, not yet assumed to be a complete implementation/content schema.

A dedicated catalog/domain validation pass should next:

- compare every catalog family against the stabilized domain;
- add missing functional dimensions/rows where required;
- preserve properties vs capabilities vs affordances vs relations vs state-band distinctions;
- identify interactions, transformations, assembly roles, environmental responses and project dependencies;
- avoid introducing recipes, object-pair APIs or duplicate runtime state into the catalog;
- preserve visual/art requirements and production status as independent dimensions.

---

# Remaining non-blocking questions

These may be resolved during module/type design, catalog normalization or implementation without reopening product discovery by default:

1. exact spatial topology/navigation representation;
2. body mutation proposer API beneath World authority;
3. concrete shallow animal behavior representation;
4. environmental/dynamic-process persistence thresholds;
5. final bounded property catalogue and registered derivation policies;
6. exact `SemanticConceptId` boundaries;
7. concrete content serialization format;
8. presentation adapters for `InteractionRegion`, anchors and assembly sockets;
9. deterministic tie-break encoding for simultaneous semantic boundaries;
10. minimal reconstruction policy for save occurring mid-investigation;
11. concrete coarse representation used for protection coverage/gaps.

These are implementation/content-definition questions, not evidence that the current domain needs another broad state owner.

---

# Documentation consolidation status

The repository now uses [`docs/README.md`](README.md) as the documentation map.

Key policy:

- canonical documents own current rules;
- specialized appendices refine narrow concerns;
- fixtures/regressions are supporting evidence, not default required reading;
- brainstorming and handoffs are historical/operational evidence;
- new edge cases should normally update an existing owner rather than create another permanent top-level specification.

One known consolidation target remains: the canonical refinements in `DOMAIN_OPERATION_REFINEMENTS.md` should eventually be absorbed into `DOMAIN_OPERATIONS.md` when that operation surface is next structurally edited. Until then, the refinement document owns the newer signatures it explicitly supersedes.

---

# Recommended next work

Two streams can now proceed without changing each other's authority boundaries:

## Runtime/module stream

1. define language-neutral package/module responsibilities and dependency direction;
2. map state owners versus derived services;
3. separate content registries/definitions from runtime instances;
4. define orchestration/application dependencies without making the application layer a state owner;
5. define presentation/Godot adapters outside authoritative domain modules;
6. then introduce concrete GDScript/runtime representations.

## Asset-catalog normalization stream

Execution handoff: [`handoffs/asset-catalog-functional-domain-normalization.md`](handoffs/asset-catalog-functional-domain-normalization.md).

1. validate the catalog against product + stabilized domain;
2. extend the catalog to include missing functional requirements and content families;
3. resolve ambiguous rows or misplaced semantics;
4. retain art/production requirements as a parallel dimension rather than the catalog's sole purpose;
5. leave domain primitive changes to explicit canonical-domain review.
