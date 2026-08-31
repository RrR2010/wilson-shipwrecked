# Discovery Status

## Current phase

Product/behavior discovery, architecture contracts, the language-neutral functional-domain stabilization, and the first functional-domain normalization of the cross-cutting asset catalog are complete enough to proceed.

The current engineering/design phase is:

```text
package/module dependency layout
→ concrete domain types
→ declarative content fixtures
→ first vertical slice
→ deterministic regression execution
→ presentation adapters
```

In parallel, model/content production can now consume the normalized [`asset-catalog/`](asset-catalog/) directly. New content should extend that schema rather than returning to the historical brainstorming rounds as a production backlog.

For documentation navigation and authority, use [`README.md`](README.md). This file intentionally contains status only.

---

# Closed gates

Current status:

```text
Product / behavioral discovery            PASS
Architecture responsibility boundaries    PASS
Simulation contracts / orchestration      PASS
Mutation authority                        PASS
Guards / bounded calibration              PASS

Structural functional domain              PASS
Vocabulary normalization                  PASS
Representative-scene regression           PASS
Operation regression                      PASS
Functional asset breadth                  PASS
Asset catalog functional normalization    PASS
Asset catalog scene-coverage regression   PASS WITH LOCAL CONTENT FOLLOW-UPS
Gradual exploration / evidence             PASS
Composite-object semantics                PASS
Environmental protection / exposure       PASS
Scientific Method micro-loop              PASS
Falling Palm hazard micro-loop            PASS
Sabotaged Storage epistemic micro-loop    PASS
Improvised hammer fixture                 PASS
Cloth/shelter/weather fixture             PASS
```

**Functional-domain stabilization gate: PASS.**

**Asset-catalog functional normalization gate: PASS for the current P0/P1 catalog breadth.**

**Representative-scene content regression: PASS for the accepted phenomenon suite, with localized content follow-ups documented in `asset-catalog/SCENE_COVERAGE.md`.**

The validated model did not require separate state-owning systems for crafting, tool quality, shelter, exploration, tactical planning, hazard projection, suspicion/investigation, wet-material state, fallen-opportunity objects or storm-debris clusters. Those concerns remain compositions, projections, processes, ordinary world outcomes or production adapters inside existing authority boundaries.

The 40-scene catalog regression additionally found:

- four useful content extensions: wearable/hat-like salvage, decorative shell/curio content, a generic decorative/sculptural arrangement pattern, and a distant human-contact Director presentation family;
- one deferred additional-location content extension for the neighboring-islet scene;
- two historical scenes whose literal versions remain intentionally reshaped by later canonical decisions (`The Unwanted Rescue`, `Not Now, Humanity`).

The worn-object case reuses the existing possession relation plus a bounded qualifier/body-slot presentation adapter; it does not justify `worn_by`, an equipment system or another state owner.

None of these findings reopen the domain/system ownership gate.

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

The repository uses this ownership split:

```text
docs/asset-catalog/
  cross-cutting functional + visual modeled-content requirements
  + production backlog/status

docs/art/
  visual language, references and artistic production process

docs/brainstorming/functional-asset-catalog/
  historical breadth exploration / upstream evidence
```

The initial catalog normalization pass is complete. The catalog now provides:

- a separate functional `Spec` lifecycle (`UNREVIEWED`, `PARTIAL`, `ALIGNED`, `BLOCKED`) independent from production `Status`;
- a compact semantic token grammar for materials, properties, capabilities, affordances, relations, assembly roles/slots, interaction regions, transformations, environmental behavior, evidence, actions, scenes and projects;
- normalized P0/P1 entity/project/living-world rows against the stabilized domain;
- semantic project/component roles instead of object-type recipes;
- explicit transformation-descendant handling for coconut/fish and detachable components;
- foundational construction, tinder, water, mushroom, clothing and utility families that were missing from the art-seeded catalog;
- explicit reclassification of wet-material states, fallen-object opportunities, roof damage, storm debris, light-prop displacement and perch sockets as presentation/process/adapter requirements rather than fake entities;
- preserved art references and model-production status as independent concerns;
- `asset-catalog/SCENE_COVERAGE.md` as the regression view from the 40 historical representative scenes back into domain/content requirements.

No new broad domain primitive was required by this pass.

Catalog additions remain open-ended content work. A newly proposed family should use the admission rules in `asset-catalog/README.md`; if it exposes a genuine reusable domain gap, update the canonical owning domain document explicitly rather than introducing the primitive only in a row.

---

# Remaining non-blocking questions

These may be resolved during module/type design, content authoring or implementation without reopening product discovery by default:

1. exact spatial topology/navigation representation;
2. body mutation proposer API beneath World authority;
3. concrete shallow animal behavior representation;
4. environmental/dynamic-process persistence thresholds;
5. final bounded property catalogue and registered derivation policies;
6. exact `SemanticConceptId` boundaries;
7. concrete content serialization format;
8. presentation adapters for `InteractionRegion`, anchors, body-slot possession qualifiers and assembly sockets;
9. deterministic tie-break encoding for simultaneous semantic boundaries;
10. minimal reconstruction policy for save occurring mid-investigation;
11. concrete coarse representation used for protection coverage/gaps.

These are implementation/content-definition questions, not evidence that the current domain needs another broad state owner.

---

# Documentation consolidation status

The repository uses [`docs/README.md`](README.md) as the documentation map.

Key policy:

- canonical documents own current rules;
- specialized appendices refine narrow concerns;
- fixtures/regressions are supporting evidence, not default required reading;
- `asset-catalog/` owns normalized cross-cutting content requirements and production tracking;
- brainstorming and handoffs are historical/operational evidence;
- new edge cases should normally update an existing owner rather than create another permanent top-level specification.

One known consolidation target remains: the canonical refinements in `DOMAIN_OPERATION_REFINEMENTS.md` should eventually be absorbed into `DOMAIN_OPERATIONS.md` when that operation surface is next structurally edited. Until then, the refinement document owns the newer signatures it explicitly supersedes.

---

# Recommended next work

Two streams can proceed without changing each other's authority boundaries:

## Runtime/module stream

1. define language-neutral package/module responsibilities and dependency direction;
2. map state owners versus derived services;
3. separate content registries/definitions from runtime instances;
4. define orchestration/application dependencies without making the application layer a state owner;
5. define presentation/Godot adapters outside authoritative domain modules;
6. then introduce concrete GDScript/runtime representations.

## Content/model-production stream

1. begin with `Spec=ALIGNED`, `P0` catalog rows and their dependencies;
2. build the foundational interchangeable component/material grammar before bespoke hero assets;
3. preserve mandatory regression contrasts such as empty/full container, transparent/opaque container, tight/loose tool binding, loose/tensioned cloth and mismatched compatible shelter repair;
4. validate real generated assets against interaction-region/adapter and gameplay-camera requirements;
5. update production `Status` without changing functional `Spec` unless new evidence changes the brief;
6. add new families through the normalized catalog admission rules rather than copying brainstorming candidates mechanically;
7. close the localized scene-coverage content follow-ups in `asset-catalog/SCENE_COVERAGE.md` before claiming exhaustive 40-scene content coverage.

Historical execution handoff: [`handoffs/asset-catalog-functional-domain-normalization.md`](handoffs/asset-catalog-functional-domain-normalization.md).
