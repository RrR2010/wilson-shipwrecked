# Handoff — World Generation to Representative Gameplay Semantics

Status: ACTIVE after merge of the product new-run/world-generation vertical.

## Transition objective

Continue from the validated product-level fresh-run generation boundary into the next major runtime vertical: richer representative gameplay semantics driven by player-visible scene needs.

Do not reopen bootstrap/runtime ownership unless a representative scenario proves a concrete gap.

## Validated starting point

The project now has a complete upstream fresh-run path:

```text
ProductNewRunParameters
+ ProductWorldGenerationProfile
+ sealed ContentRegistry
+ explicit gameplay seed
→ ProductNewRunGenerator
→ deterministic durable SimulationBootstrapDefinition causes
→ NewRunDefinition
→ NewRunBootstrapService
→ authoritative owners
→ RunRuntimeComposer
→ reconstructible runtime
```

Validated generated causes currently include:

```text
Wilson semantic start place
bounded entity populations
bounded unique World relations between generated entity families
initial DriveState values
environment weather/daylight
run identity / gameplay seed
initial God Power / permissions
```

Generation deliberately remains upstream of runtime authority. It does not read Godot nodes, transforms, colliders, navigation state or scene identity.

## Closed contracts

### Determinism

Equivalent semantic authored inputs plus the same gameplay seed generate semantically equivalent bootstrap causes.

Stable semantic ordering is applied before seeded selection, so merely reordering authored arrays does not perturb generation.

Different seeds produce bounded variation rather than uncontrolled mutation.

### Authored-content admission

Generation requires a sealed `ContentRegistry` and refuses entity generation rules whose `EntityTypeId` has no authored `EntityDefinition`.

Invalid generation fails explicitly. Examples covered by regression include:

```text
generation_content_not_sealed
generation_profile_mismatch
generation_missing_entity_definition
duplicate_generated_entity_id
generation_relation_insufficient_candidates
```

There is no hidden post-bootstrap repair pass.

### Relation generation

`ProductRelationGenerationRule` declares bounded semantic relations between generated entity families.

The generator selects unique subject/object pairs deterministically and emits ordinary `RelationBootstrapSeed` values. Relations therefore enter the same `WorldRelationStore` bootstrap path used by restore and deterministic scenarios.

### Authority boundary

The following remain inputs/content, not runtime owners:

```text
ProductNewRunParameters
ProductWorldGenerationProfile
ProductEntityGenerationRule
ProductRelationGenerationRule
ProductNewRunGenerator
NewRunDefinition
```

Do not introduce a persistent `WorldGeneratorState` or equivalent authority merely to retain generation recipes after bootstrap.

## Validation checkpoint

Operator-reported strict local validation after the final relation-generation changes:

```text
PASS product_new_run_generation_test

RESULT: 80 PASS / 80 TOTAL
PASS headless_suite (80 tests)
```

A transient `deterministic_playable_bootstrap_scenario_test` navigation failure occurred during one full-suite run. The same test passed immediately in isolation, and the subsequent strict full suite passed 80/80. The world-generation branch does not modify motion/navigation files.

## Primary implementation files

```text
src/application/bootstrap/product_new_run_parameters.gd
src/application/bootstrap/product_entity_generation_rule.gd
src/application/bootstrap/product_relation_generation_rule.gd
src/application/bootstrap/product_world_generation_profile.gd
src/application/bootstrap/product_new_run_generation_result.gd
src/application/bootstrap/product_new_run_generator.gd

tests/headless/product_new_run_generation_test.gd
```

Existing downstream boundaries that must remain reused:

```text
src/application/bootstrap/new_run_definition.gd
src/application/bootstrap/new_run_bootstrap_service.gd
src/application/bootstrap/simulation_bootstrap_definition.gd
src/application/bootstrap/simulation_owner_bootstrapper.gd
src/application/bootstrap/relation_bootstrap_seed.gd
src/application/bootstrap/run_runtime_composer.gd
```

## Recommended next major vertical

Implement one richer representative gameplay slice that forces a genuinely missing semantic capability rather than expanding foundation breadth abstractly.

Preferred evidence order:

```text
docs/SCENE_VALIDATION.md
→ docs/brainstorming/representative-scene-catalog.md
→ docs/asset-catalog/SCENE_COVERAGE.md
→ relevant canonical domain/behavior contracts
→ inspect current runtime capability
→ select the smallest missing reusable primitive
```

Leading candidates from the current validated gap list are:

1. richer Gerald behavior / Wilson-Gerald relationship semantics;
2. Wilson-relative learned route/escape reasoning;
3. physical accident authoring only where a representative scenario requires it.

Prefer a vertical that reaches a player-visible causal outcome through existing authority boundaries, not a broad subsystem implemented without an executable representative use.

## Suggested next cut boundary

A good next session-level objective is:

> one non-food representative autonomous gameplay scenario with a real missing semantic primitive, validated end-to-end through ordinary owners, action/world causality and Godot adapters where spatial behavior matters.

Close that session when the selected scenario is green under the strict runner, canonical status/docs are aligned, and a new transition handoff exists. Do not recursively add a second unrelated scenario in the same session merely because adjacent gaps are visible.

## Explicit non-goals for the next agent

Do not, without new evidence:

- generalize a production scene-binding/host composer before a second real production use proves its shape;
- add more world-generation seed families merely to mirror every `SimulationBootstrapDefinition` field;
- turn generation recipes into runtime authority;
- use scene transforms or Godot identity as generated World truth;
- refactor the long bootstrap/snapshot constructors cosmetically;
- begin snapshot migration work unless the chosen gameplay vertical creates persistence pressure;
- create a universal event bus, state container or graph authority.

## Required workflow

Start from latest `origin/main` after this PR is merged, on a new short-lived branch.

For runtime/domain changes, final admission remains:

```powershell
.\tests\run_headless_tests.ps1
```

Do not update `docs/DISCOVERY_STATUS.md` with a new validated checkpoint until the operator reports the strict local Godot gate successful.