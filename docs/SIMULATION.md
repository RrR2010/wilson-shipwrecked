# Simulation Design

## Principle

The simulation should generate situations from reusable rules. Do not encode the future as a large branching story tree.

Product discovery has refined this principle further:

> Prefer a compact grammar of properties, physical actions, transformations, knowledge and memory that can produce both sensible and comically counterintuitive solutions.

This document records **simulation behavior and vocabulary**, not a final implementation architecture.

## Core vocabulary

```text
Entity + Properties + State
          |
          v
   Physical Affordances
          |
          v
        Actions
          |
          v
  Effects / Transformations
          |
          v
      World State
          |
          v
 Knowledge / Memory
```

### Entity
A stable participant in the world: Wilson, a tree, crate, fish, shelter, tool, resource pile, animal, environment region or interaction anchor.

Entities need not all be player-manipulable. `sea`, `shoreline`, `horizon` or a campfire cooking anchor may participate in interactions without behaving like portable objects.

### Property / capability
Facts enabling generic rules. Prefer graded reusable properties where useful rather than enumerating object pairs.

Examples:

```text
hardness: VERY_LOW | LOW | MEDIUM | HIGH | VERY_HIGH
risk: VERY_LOW | LOW | MEDIUM | HIGH | VERY_HIGH
throwable
container
flammability
edible
impact_tool
breakable
```

Properties are authoritative world truth. They are **not automatically Wilson knowledge**.

### State
Mutable authoritative values such as health, wetness, quantity, open/closed, burning, location and ownership. Prefer explicit object transformation when a state represents a meaningful new object form and doing so simplifies interaction rules.

### Affordance
A currently possible attempt derived from the initiating entity/action plus context. An affordance means that something can be attempted, not that Wilson wants to do it or knows the result.

### Action
A reusable interaction with semantic roles. Actions may have different arities.

```text
eat(target)
sleep()
throw(item, target)
hit(target, tool)
put(item, container)
transfer(content, source, target)
```

Do not force naturally ternary interactions into artificial project steps merely to keep actions binary.

### Effect / transformation
The authoritative consequence of an action. Effects may change state, create/destroy entities or transform one object form into another.

```text
coconut -> opened_coconut -> empty_coconut
```

Transformation definitions decide which Wilson-related historical metadata transfers to the result.

## Generic interactions and thresholds

Prefer generic rules such as sufficient impact/hardness against a breakable target over bespoke pair rules.

Conceptually:

```text
HIT(target, tool)

requires:
  tool supports impact
  target can receive impact

effects:
  compare relevant graded properties
  apply generic reaction
  transform target/tool if thresholds are crossed
  produce visual feedback
```

The same physical action may therefore work with a stone, hammer or absurdly heavy bowling ball without defining three separate coconut-opening recipes.

A valid physical action does not guarantee an interesting result. Throwing a coconut at a wall may simply produce generic impact feedback and no transformation.

## Exploration and learned interactions

Separate physical exploration from semantic learned interactions.

### Physical exploration

Wilson begins with a basic vocabulary such as observing, carrying, throwing and hitting. The initiating object determines which exploration actions are exposed. A throwable coconut can expose `Throw at...` with nearby targets, including useless targets.

This intentionally allows bounded brute-force experimentation.

### Learned interaction

After observing a useful relationship, Wilson may know a semantic intention such as:

```text
open coconut with impact tool
extinguish fire with suitable material
cook food at fire
```

The presentation can then expose the semantic interaction instead of requiring the player/Wilson to reconstruct it as a raw physical experiment every time.

### Direction matters

Exploration may reveal different knowledge depending on the initiating side:

```text
coconut -> hit with -> stone
  may reveal target resistance/breakability

stone -> hit -> coconut
  may reveal tool hardness/impact capability
```

## Knowledge graph

Progression should be modeled conceptually as a graph of discovered relationships rather than a visible linear technology tree.

```text
object/type/category
       |
       v
properties / expectations
       |
       v
physical actions
       |
       v
observed outcomes
       |
       v
learned interactions
       |
       v
new projects / affordances / locations
```

Maintain separation between:

- **world truth:** authoritative properties and state;
- **Wilson expectations:** inferred but unconfirmed assumptions;
- **Wilson knowledge:** learned/confirmed facts and interactions;
- **player knowledge:** possibilities revealed through play;
- **LLM context:** bounded projection for one request.

### Discovery scope

Different properties may use different discovery semantics:

- universal/basic knowledge;
- discovered once and generalized;
- discovered per object type.

Categories may generate expectations. A new stone-like object can inherit an expectation of high hardness while retaining an authoritative property that contradicts it, allowing surprise when experimentation disproves the assumption.

### Confidence

Knowledge may have confidence/reinforcement. Repeated successful use increases confidence. Failure may lower confidence or create a negative expectation. Basic established knowledge should normally remain stable; transient contextual conclusions may decay.

## Object identity and historical metadata

Functional properties and Wilson-related historical metadata are separate.

An entity instance may accumulate history such as:

```text
seen
explored
feared
liked/disliked
moved unexpectedly
interpreted as mysterious/divine
```

Transformation rules explicitly determine which historical metadata transfers:

```text
coconut_17 [explored, ...]
  -> opened_coconut_17 [explored, ...]
```

Detailed lineage through one-to-many or many-to-one crafting is not a default requirement. Rare/narratively meaningful transformations may opt into lineage markers.

This model must support instance-specific relationships such as Wilson's rivalry with one particular monkey or distrust of one particular campfire.

## Complex entities and anchors

Simple objects should generally remain simple. Complex entities may expose parts/anchors where the interaction value justifies it.

Examples:

- tree: trunk, fruit and relevant interaction anchors;
- modular shelter: floor/wall/roof anchors;
- environment: shoreline/horizon/cooking locations.

Anchor points are an interaction vocabulary concept here; their rendering/scene implementation belongs to architecture/asset documentation.

## Action desirability

Keep these questions distinct:

1. **Is the action physically possible?**
2. **Does Wilson know/expect what it does?**
3. **Does Wilson currently want to do it?**

A physically possible action can be unknown and undesirable. Curiosity, boredom, player suggestion, emotional state and a caution/recklessness tendency may occasionally make low-value or absurd experiments attractive.

Urgent survival needs should dominate trivial curiosity. Wilson should not ignore extreme hunger merely to investigate a crab unless an exceptional state/event justifies it.

## Autonomous choice — behavioral requirements

The exact decision algorithm remains architectural work. Product behavior requires autonomous choices to respond to at least:

- need urgency;
- current opportunities;
- curiosity/novelty;
- risk and caution/recklessness;
- preferences;
- memories and instance relationships;
- habits;
- active projects;
- player suggestions;
- directed-event bias.

Wilson remains autonomous in every mode. Suggestions increase propensity but do not become commands.

A suggestion may normally be attempted once plus one or two insistences within a time window. Repetition should increase acceptance probability while still permitting refusal and visible/thought-bubble reaction.

## Projects

Projects are persistent intentions composed of short stages rather than continuous work actions.

Wilson may maintain roughly three projects, preferably one principal and up to two secondary/paused projects.

A project becomes available only when Wilson has enough initial knowledge/resources for the intention to make sense. Example: he should not decide to replace a floor with planks before learning how to produce planks.

After completing a stage, immediate continuation becomes less likely and its probability rises again over time. Projects therefore interleave with ordinary life.

Functional projects compete according to current state/priority. Decorative projects become more attractive when basic needs are reasonably satisfied or Wilson is bored.

Abandoned projects may be dismantled to recover supported resources. Most ordinary projects should nevertheless tend toward eventual completion.

Target product pacing:

```text
simple multi-stage project: ~2–5 in-game days
complex project: ~10–20 in-game days
```

Most constructions are predefined project families. The shelter may be partially modular through floor/wall/roof anchors and staged improvements.

## Habits

Habits are medium-term context → behavior associations rather than permanent personality traits.

Conceptually:

```text
WHEN wakes_up
THEN look_at_horizon
strength: HIGH
```

Repeated behavior reinforces the association; disuse weakens it. Strong emotional consequences may reinforce or suppress it. Habits can produce routines, running gags and temporary obsession-like behavior without requiring a separate obsession system.

## Preferences and emotions

Preferences may exist at both type/class and individual-instance level.

Preference change should primarily follow **direct interaction outcome + resulting emotion**, avoiding arbitrary correlation with unrelated simultaneous context.

Urgent needs can overwhelm preferences. Aesthetic preferences for colors/materials may influence decorative choices.

The final trait/emotion model is intentionally open pending research. Current behavioral requirements include transient emotions, curiosity, independence, faith toward player intervention, and a caution/recklessness dimension affecting risky exploration.

## Player intervention and God Power

The player changes the environment and suggests actions; the player does not directly drive Wilson's body/actions.

God Power is a single intervention budget in the primary mode. Product rules currently require:

- most interventions consume it;
- suggestions are inexpensive;
- intervention cost rises broadly with magnitude/complexity;
- passive gain accelerates while the player refrains from intervention, up to a cap;
- any intervention breaks that streak;
- achievements/milestones grant immediate bonuses;
- offline accumulation has a cap;
- resurrection never requires God Power.

Exact values require scene-driven calibration rather than being fixed here.

## Event Director and directed scenes

External events introduce novelty but remain constrained by the world model.

An event template may define:

- eligibility conditions;
- cooldown/frequency/rarity;
- required world/knowledge prerequisites;
- spawn/location requirements;
- parameter slots;
- authoritative effects/actions;
- presentation hints;
- follow-up hooks.

### Directed scenes

Some rare events temporarily bias Wilson strongly toward a coherent action sequence. This is not a cutscene or deterministic script.

Example:

```text
SHIP_PASSING
  40% -> run and wave
  40% -> hide
  10% -> alternate response
  10% -> break scene and return to normal autonomy
```

Normal high-priority needs or surprising new affordances may break the scene. Some extreme player interventions may be temporarily restricted for readability, but the simulation remains authoritative.

Directed scenes may be extremely rare and gated by combinations of probability and prerequisites. Do not guarantee complete content exposure to every player.

## Narrative grammar

Micro-stories may still be described through semantic beats:

```text
SETUP -> INTENTION -> ATTEMPT -> COMPLICATION -> REACTION -> RESOLUTION/ABANDON
```

This grammar is a design aid and possible event/director constraint, not permission to bypass simulation rules.

## Death and resurrection

Wilson can die. Death finishes enough of the current visible sequence to feel coherent before simulation pauses for the player choice.

Resurrection:

- is always available;
- costs no God Power;
- does not create conscious knowledge of death;
- may produce strong short-term fear;
- may alter medium-term caution/curiosity/faith;
- leaves a long-lived negative association with the cause.

No rewind mechanic is required.

## Time

Current target:

```text
1 in-game day ~= 15–20 real-time minutes
~70% daylight / ~30% night
```

World time is independent of wall-clock time while playing. Wilson normally sleeps for much of the night. Time acceleration is only available while Wilson sleeps and returns to normal automatically when he wakes. Pause is always available.

## Offline catch-up

Offline simulation is optional per player settings.

When enabled, it should advance the world more conservatively than active play. It may progress ordinary projects, learning, relationships and state, but must not:

- kill Wilson;
- resolve major rare/directed scenes out of view;
- unlock major additional areas;
- produce extreme irreversible surprises.

A rare/directed opportunity may be queued for active play rather than resolved offline.

Produce a structured catch-up history suitable for Wilson's diary. Wilson's diary contains only events Wilson could know.

## Procedural world generation

Use a reproducible seed and separate generation stages conceptually:

```text
seed
 -> macro terrain / coastline / elevation
 -> gameplay landmarks
 -> resource constraints
 -> object clusters
 -> decorative scatter
 -> visual variants
```

The main world remains a small tropical island. Do not require a deep ecosystem. Supported environmental evolution includes vegetation growth, fruit fall/rot, objects arriving from the sea and weather-driven priority changes.

Initial optional rare areas are a small neighboring island and an abandoned stranded/wrecked ship. They remain time-limited excursions; the home island is the persistent center.

## Scene-driven calibration

Before fixing detailed structures, weights or balance, validate the simulation against a catalog of desirable scenes.

For each scene, record:

1. visible setup and beats;
2. plausible alternate outcomes;
3. required objects/properties;
4. knowledge assumptions and discoveries;
5. needs/status pressure;
6. trait/emotion/risk modifiers;
7. relevant memories/habits;
8. project state;
9. event/director bias;
10. possible player interventions and God Power cost class;
11. what persists afterward.

Then create a cross-scene matrix showing which systems materially change which scenes. A proposed field/system that changes no desirable scene should be challenged or deferred.

This matrix is the preferred bridge from product design into later data-model and architecture work.

## Balance through simulation

Once architecture work begins, provide a headless runner capable of many simulated days/worlds. Useful metrics will include:

- action/interaction frequencies;
- exploration success/failure;
- knowledge acquisition;
- need crises;
- risk-taking frequency;
- project completion times;
- idle time;
- repeated loops;
- directed-event coverage/break rate;
- God Power generation/spend patterns;
- diversity between seeds.

A system with huge theoretical combinatorics but repetitive visible behavior is not diverse enough.

## Open design work before architecture

Do not treat the concepts above as a final data schema. Before architecture is designed:

- research a minimal useful psychological model for Wilson;
- build the representative scene catalog;
- build the scene × system influence matrix;
- derive a first vocabulary of verbs/properties/interactions from those scenes;
- calibrate survival depth and God Power qualitatively;
- define the vertical-slice subset.
