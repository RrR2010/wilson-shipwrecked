# Domain Vocabulary Regression

## Purpose

Validate the normalized vocabulary in `DOMAIN_VOCABULARY.md` against the representative scene catalog and the functional domain model.

This regression asks a narrower question than `DOMAIN_REGRESSION.md`:

> Can the same small vocabulary describe the important distinctions in the scenes without aliases, hidden type coercions, scene-specific terminology or loss of authority boundaries?

Result: **PASS**. No representative scene requires reverting any normalized distinction or adding a new broad vocabulary family.

---

# 1. Reference taxonomy regression

## Instance-specific history

Scenes:

- The Good Chair;
- The Traitorous Fire;
- Gerald;
- Someone Moved the Rock;
- Gerald Is Missing.

Required refs:

```text
Entity(EntityId)
Place(PlaceId)
```

This preserves the difference between:

```text
this particular fire pit
!=
fire pits in general
```

and:

```text
Gerald
!=
crabs in general
```

PASS.

## Category/type generalization

Scenes:

- The Mushroom;
- Too Hot;
- Scientific Method;
- The Perfectly Good Bowling Ball.

Required refs:

```text
EntityType(EntityTypeId)
Category(CategoryId)
```

PASS. Generalization does not require converting runtime instances into type IDs.

## Wilson and Presence

Scenes:

- Absolutely Not;
- The Benefactor;
- The Gift Test;
- Sabotaged Storage;
- The Experiment.

The explicit refs:

```text
Wilson
Presence
```

are cleaner than magic entity IDs. Presence remains a relationship/cognition subject, not a physical entity.

PASS.

---

# 2. Property / capability / category regression

## Bowling Ball

Required distinction:

```text
category: unusual debris / bowling ball
capability: impact_tool
properties: hardness, weight/impact capacity
```

The solution works because capability + properties satisfy the generic interaction rule; category does not grant physical behavior.

PASS.

## Mushroom

```text
category: mushroom / unfamiliar food
capability/property: potentially edible / consumable semantics
Wilson belief: uncertain harmful/edible proposition
```

Classification, physical participation and Wilson knowledge remain separate.

PASS.

## Umbrella

The umbrella may carry:

```text
category.umbrella/debris
capability.deployable / portable_cover
properties for condition/durability
```

Wilson's expectation that it protects from rain is a belief, not a capability value.

PASS.

---

# 3. Relation taxonomy regression

## Missing Spoon

World truth:

```text
on_top_of(spoon, rock)
```

Wilson expectation:

```text
expected_relation(spoon, beside, cooking_area)
```

No special missing-object primitive is required.

PASS.

## Sabotaged Storage

World truth changes from:

```text
inside(material, storage)
```

to dispersed place/support relations.

Wilson's expectation is proposition state, not duplicated inventory state.

PASS.

## Falling Palm

A clutter object may semantically:

```text
blocks_route(clutter, escape_route/place relation)
```

while actual navigation remains derived from route/spatial queries.

PASS.

## Interior Design

The arrangement can be represented by ordinary support/spatial relations plus Wilson expected-relation propositions.

No `DecorationLayout` primitive is required in the core domain.

PASS.

---

# 4. Predicate-family regression

## Physical predicates

Scenes:

- Scientific Method;
- Bowling Ball;
- Faster Than Walking;
- Falling Palm.

Need only authoritative world/body predicates for physical legality.

PASS.

## Cognition predicates

Scenes:

- Statue of Gerald;
- Traitorous Fire;
- Too Hot;
- Benefactor.

Authored eligibility/desirability may query association, belief, habit or presence state through bounded cognition predicates.

PASS.

## Lifecycle predicates

Scenes:

- One More Piece;
- Roof or Table?;
- Signal Fire.

Project and DirectedEvent lifecycle conditions remain distinct from physical predicates.

PASS.

## RegisteredDomainPredicate escape hatch

No catalog scene currently demonstrates a semantic that definitely requires an untyped/general callback.

Therefore:

```text
RegisteredDomainPredicate
```

remains an exceptional extension point, not the normal authoring mechanism.

PASS.

---

# 5. Action / SemanticIntention / Affordance regression

## Scientific Method

Possible physical actions:

```text
pull
hit
inspect
```

Wilson intention:

```text
open_unknown_container
```

Repeated action changes do not require replacing the higher-level intention.

PASS.

## Bottle

Affordances can remain available while the semantic intention is suspended for hours.

```text
physical affordance exists
!=
current Wilson intention
```

PASS.

## One More Piece

```text
semantic intention: continue shelter section
physical actions: carry/place/attach component
```

Hunger may replace/suspend the intention without pretending an individual placement action is the entire project goal.

PASS.

## Learned coconut opening

```text
KnowledgeDefinition
→ LearnedSemanticInteraction
→ SemanticIntention(open_coconut_with_impact_tool)
→ physical action hit/drop/etc.
→ InteractionRule validation
```

PASS.

---

# 6. Effect / Event / Observation regression

## Falling Palm

Authoritative mutation may include:

```text
SpatialMutationEffect
BodyMutationEffect
EntityLifecycle/PropertyMutationEffect
```

After commit, emitted `WorldEvent`s describe the fall/impact/damage.

Wilson receives `ObservedEvent`s only for accessible portions.

PASS.

## Unwanted Rescue reshape

Player intervention mutates the world first. The world then emits facts. Wilson's trust change derives only after perception/attribution.

The normalized distinction prevents this invalid shortcut:

```text
player effect → trust mutation
```

PASS.

## Scientific Method

`SemanticOutcomeTag(container_dented)` / `DiagnosticFeedback(material_too_soft)` may coexist with a `PARTIAL` or `NO_EFFECT` classification.

The vocabulary does not need a fake success result to make failure learnable.

PASS.

---

# 7. Belief / Knowledge regression

## Scientific Method

Evidence modifies propositions about tool/material effectiveness.

An operational threshold may satisfy:

```text
KnowledgeDefinition(open_container_by_impact)
```

without copying facts into a second KnowledgeStore.

PASS.

## Legacy Knowledge

Cross-run state stores only stable `KnowledgeId`s. New-run bootstrap creates canonical proposition beliefs from the definition.

This avoids:

```text
old BeliefEntry + old evidence provenance
```

being copied into a new Wilson.

PASS.

## I Hate Mushrooms

Cause-of-death danger belief/association survives resurrection within the run; it is unrelated to Legacy Knowledge.

PASS.

---

# 8. DirectedEvent / WorldEvent regression

## Signal Fire

The boat opportunity is:

```text
DirectedEventInstance
```

The boat appearing/moving, fire changing and signal effects are:

```text
WorldEvent
```

Wilson observing the boat/fire is:

```text
ObservedEvent
```

This prevents a Director event object from becoming authoritative world history.

PASS.

## Not Now, Humanity reshape

A DirectedEvent may expire because Wilson chose another legitimate intention. No special event-protection semantics are required.

PASS.

---

# 9. Actor terminology regression

## Gerald

Gerald is simultaneously:

```text
Entity(EntityId)
+ shallow ActorRuntimeState
+ subject of Wilson beliefs/associations/habits
```

No `NPCRelationship`, `Pet`, `Rival` or animal cognition vocabulary is necessary.

PASS.

---

# 10. Terms rejected by regression

The following candidate primitives are unnecessary or actively harmful:

```text
Recipe
KnowledgeStore separate from BeliefStore
InventoryAggregate as universal world truth
FavoriteObject
Rival
Grudge
Routine
Ownership
SceneEvent as both Director and world fact
GenericDomainContext
GenericExecuteScriptEffect
ObjectState Variant bag
```

All corresponding scene phenomena compose from the normalized vocabulary.

---

# 11. Remaining vocabulary pressure points

These are not blockers, but should receive focused review before implementation syntax is chosen.

## 11.1 Property versus BodyCondition

Some values such as `wetness` exist on Wilson body and may also exist as an entity property for clothing/materials.

Rule:

- use `WilsonBodyState` for Wilson physiological physical truth;
- use entity properties/environment processes for non-Wilson material state;
- use drives for Wilson motivational interpretation.

Do not collapse them merely because they share a word.

## 11.2 Place versus Region

Keep both only if route/history/content authoring needs the distinction.

Current catalog supports it:

```text
place = tide pool / camp spot / wreck deck
region = home island / neighbor island / broader beach zone
```

## 11.3 SemanticOutcomeTag versus WorldEventKind

The distinction is currently useful:

- outcome tag: composable classification used by transformations/projects/learning;
- world event kind: historical semantic occurrence emitted after authoritative commit.

Do not merge unless implementation proves one is redundant while preserving causal semantics.

## 11.4 SemanticIntention versus Project goal

Project is persistent world-outcome continuity; SemanticIntention is Wilson's current purposeful framing.

A project may source many intentions over many days.

Keep distinct.

---

# 12. Vocabulary gate

**PASS.**

The normalized vocabulary can express all representative-scene phenomenon families while preserving the central architecture invariants.

Before implementation language/package work, remaining useful domain work is now primarily:

1. define the canonical **predicate catalogue** and valid context matrix;
2. define the canonical **relation catalogue** and invariants;
3. define the canonical **effect/outcome catalogue**;
4. define the minimum **proposition/knowledge catalogue** needed for the first headless regression fixture;
5. validate those catalogues with concrete representative examples rather than adding new abstract vocabulary.
