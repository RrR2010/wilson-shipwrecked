# Product & Game Design

## Elevator pitch

**Wilson Shipwrecked** is a fullscreen living diorama about coexistence with an autonomous castaway. Wilson lives, experiments, builds, fails and develops habits on his own. The player is an unexplained presence that can interfere with the environment and suggest actions, but never puppeteer Wilson.

The target feeling combines the ambient comedy and complete visual scenes of a classic screensaver with the systemic, persistent stories of a life simulation, while avoiding the need for constant management.

> **Core fantasy:** open the game to see what Wilson is doing, then decide whether this is a moment worth interfering with.

## Product principles

1. **Autonomy first.** Wilson remains autonomous in every game mode.
2. **Watching is valid play.** The game should reward patience and remain entertaining with no input.
3. **The player intervenes; Wilson acts.** The player changes the environment and makes suggestions, not direct character commands.
4. **Stories emerge from reusable rules.** Prefer properties, interactions and consequences over enumerating object pairs or story branches.
5. **Directed scenes are probabilistic, not cutscenes.** Authored events may bias Wilson strongly toward coherent sequences, but he can still break the expected scene.
6. **History becomes scenery.** Projects, relationships, object history, damage and environmental changes remain visible.
7. **Discovery expands capability space.** Progress is primarily learning new interactions and gaining new environmental possibilities.
8. **Comedy is systemic.** Slapstick, absurdity, irony, contradiction, timing and running gags may all have real simulation consequences.

## Wilson identity

Wilson is **the Wilson**, not a fully randomized protagonist. Each run preserves a recognizable base personality while allowing randomized variation and progressive shaping by experience.

Wilson:

- knows his own name but has no required pre-island biography;
- begins as a competent adult with basic everyday and survival knowledge;
- occasionally makes unexplained jokes suggesting that he may once have believed he was a ball;
- never receives a canonical explanation for that belief;
- can develop preferences, habits, fears, relationships and changing behavioral tendencies;
- is relatively quiet: animation, reactions, grunts, shouts, swearing, onomatopoeia and occasional short lines are preferred over constant dialogue;
- may very rarely acknowledge the camera visually, but never explicitly address a player.

The standard opening is always recognizable: Wilson wakes shipwrecked with clothes, a crate, coconuts and debris. The first 1–2 minutes deliberately demonstrate autonomous exploration before teaching player interaction.

## Player role

The player does not explicitly exist inside the fiction. Wilson notices unexplained interventions and may interpret them as coincidence, danger, mystery or a divine presence.

The player may:

- inspect the world;
- move supported small objects;
- create/remove/modify supported environmental objects according to game mode and God Power;
- manipulate unexplored container contents before Wilson opens them;
- place resources so that new affordances become available to Wilson;
- suggest contextual actions;
- insist a limited number of times;
- help, sabotage or deliberately create absurd situations;
- indirectly prevent dangerous actions by changing the environment.

The player may not:

- directly move Wilson;
- remove an object from Wilson's hands;
- force an animation/action already underway to stop;
- remove Wilson's autonomy, including in Sandbox modes.

Wilson reacts when interventions occur within his awareness. An object appearing nearby may cause surprise, fear, flight, investigation or eventual habituation depending on his current state and history with the player.

## Game modes

### Conquest — primary mode

- Limited **God Power**.
- Normal discovery progression.
- Contextual suggestions and environmental intervention.
- Abstract goals/projects are primarily Wilson's autonomous domain.

### Discovery Sandbox

- Unlimited God Power.
- Normal Wilson/player discovery progression.
- Broader suggestion freedom.

### Unlimited Sandbox

- Unlimited God Power.
- Player-side possibilities are unlocked from the beginning.
- Wilson still begins with normal knowledge and remains autonomous.

## God Power

God Power is a single divine intervention currency, shown discretely in the persistent UI.

Most interventions cost God Power. Reading the diary and opening normal menus are free. Suggestions are deliberately cheap because insistence is already limited.

Costs should broadly increase with the magnitude or improbability of the intervention. Exact balance is intentionally unresolved.

God Power comes from a combination of:

- passive time;
- Wilson achievements and milestones;
- smaller rewards for interesting events.

Passive generation rewards non-interference. The longer the player goes without spending God Power, the faster passive generation becomes, up to a cap. Any intervention breaks the streak. Offline accumulation is capped.

Resurrection is always available and does not require God Power.

## Interaction grammar

Interactions use a compact grammar of verbs with typed semantic roles. Verbs may have different arities; do not force every interaction into a binary `use X on Y` model.

Examples:

```text
eat(target)
sleep()
throw(item, target)
hit(target, tool)
put(item, container)
transfer(content, source, target)
```

Complex multi-object actions are valid when the verb naturally requires them. Projects are for persistent multi-step intentions, not a workaround for verb arity.

### Exploration vs learned interactions

Unknown behavior is exposed through physical/generic verbs:

```text
Hit with...
Throw at...
Put in...
Pour into...
```

After Wilson learns a useful relationship, the same possibility may be presented semantically:

```text
Open coconut with...
Extinguish fire with...
Cook...
```

Thus:

> **physical action → experiment → observed result → learned interaction**

The UI does not expose internal properties such as `hardness` or `flammability` directly.

### Contextual selection

The initiating object determines which exploration verbs are available. A throwable coconut can expose `Throw at...` and list nearby targets, including useless ones. Clicking a wall does not need to enumerate every throwable object that could be thrown at it.

This intentionally permits bounded brute-force experimentation and absurd combinations while keeping the interaction space manageable.

Wilson may still refuse a physically valid suggestion because of risk, urgency, preference, memory or autonomy.

Suggestions for learned interactions are limited to Wilson's knowledge. Physical exploration suggestions may be available before either Wilson or the player knows their outcome, provided the required participants are locally available.

If a known interaction requires a missing participant, do not show the unavailable interaction. A separate contextual suggestion such as `Search for...` may let the player encourage Wilson to locate the missing resource first.

## Knowledge and discovery

Progression is a **knowledge graph**, not a conventional technology tree.

Conceptually it connects:

```text
objects
  ↕
categories / properties
  ↕
physical actions
  ↕
observed results
  ↕
learned interactions
  ↕
new projects / possibilities
```

Wilson does not magically know authoritative object properties. Exploration can reveal properties or specific interactions depending on direction and result.

Example:

```text
coconut -> hit with -> stone
  may teach properties of the coconut

stone -> hit -> coconut
  may teach properties/capabilities of the stone
```

Knowledge can have confidence. Repeated success can reinforce confidence; failure can reduce it or establish a negative expectation.

Properties may define different discovery behavior, for example:

- universal/basic knowledge;
- discover once and generalize;
- discover per object type.

Object categories may produce expectations before confirmation. Wilson may reasonably assume that an unfamiliar stone-like object is hard and then be surprised when pumice behaves differently.

Basic learned interactions are generally persistent. Contextual and emotional memories may decay.

## Properties and systemic reuse

Prefer reusable graded properties and thresholds over hardcoded object-pair recipes.

Instead of:

```text
stone + coconut -> opened coconut
hammer + coconut -> opened coconut
bowling ball + coconut -> opened coconut
```

a generic interaction may depend on sufficient impact/hardness versus target resistance/breakability.

Properties may be physical or semantic and may use discrete grades rather than continuous simulation:

```text
hardness: VERY_LOW | LOW | MEDIUM | HIGH | VERY_HIGH
risk: VERY_LOW | LOW | MEDIUM | HIGH | VERY_HIGH
```

This allows physically plausible but comically counterintuitive solutions, such as opening a coconut with a bowling ball.

Objects that satisfy the initiating physical action may be tried even when the target has no meaningful reaction. A banana may survive an inappropriate action, or a compatible property such as deformability may transform it into a mashed state.

## Object transformations and history

Prefer explicit object transformations over large collections of conditional states when practical:

```text
coconut -> opened_coconut -> empty_coconut
```

A transformation defines which Wilson-related instance metadata is transferred to the resulting object. Functional object properties and Wilson's historical metadata are distinct concepts.

Example: an explored coconut may remain historically `explored` after opening while an irrelevant prior taste marker may not transfer.

One-to-many and many-to-one transformations do not normally preserve detailed lineage. Specific rare/narratively important content may opt into lineage preservation.

Simple objects generally transform as wholes. Complex objects may expose functional parts/anchors when that meaningfully expands interactions, e.g. a tree with trunk, leaves and fruit.

## Instance relationships and memory

Individual entities can accumulate Wilson-specific historical metadata. This supports relationships with **that** monkey, **that** crab, **that** campfire or **that** mysterious object rather than only species-wide preferences.

Useful concepts include:

- seen/explored;
- positive/negative association;
- fear or caution;
- player interference/moved unexpectedly;
- mysterious/divine interpretation;
- memorable interaction weights.

Type/class-level preferences and instance-level preferences may coexist.

The exact ownership of memory between Wilson and entity metadata remains a design/architecture question, but product behavior must support instance-specific history.

## Wilson psychology — provisional requirements

The final psychological model is intentionally open pending focused research. Product behavior requires at least the following phenomena:

- short-term needs such as hunger and energy;
- curiosity;
- independence;
- sociability/companionship where useful;
- a caution ↔ recklessness dimension affecting risk-taking and experimentation;
- transient emotions such as fear, anger, surprise and happiness;
- preferences by type and individual entity;
- short- and long-term memories with different decay/reinforcement;
- medium-term habits;
- a player/Wilson faith relationship.

`Sanity` is not yet a committed concept. The intended behavior is closer to a caution/recklessness axis: one extreme is highly risk-averse, while the other permits strange experiments, more self-talk and larger behavioral variance. Research should determine whether this needs one or multiple dimensions.

Faith is specifically about Wilson's interpretation of player intervention. Higher faith may increase willingness to accept suggestions, reduce surprise at interventions and enable ambiguous lines such as `Is someone watching me?`. Faith is not equivalent to low mental health.

### Preferences

Preferences change primarily through direct outcomes and the emotions produced by those outcomes, not arbitrary simultaneous context.

They may exist at both type/class and instance level and can affect choice when urgent needs do not dominate. Wilson may also develop aesthetic preferences such as favored colors/materials.

### Habits

Habits are medium-term context → behavior associations rather than permanent traits.

Example:

```text
WHEN wakes_up
THEN look_at_horizon
strength: high
```

Repetition reinforces them; disuse weakens them. Strong emotional outcomes may reinforce or suppress them. Habits can create running gags and temporary obsessions without requiring a separate obsession system.

## Projects and construction

Wilson may maintain up to roughly three projects, with a preferred pattern of one principal project and up to two secondary/paused projects.

Projects are persistent intentions composed of short work stages. Wilson should not work continuously until completion:

```text
work stage
-> eat
-> investigate something
-> rest
-> return later
```

After completing a stage, immediate continuation becomes less likely and rises again over subsequent time. This makes projects part of Wilson's life rather than progress bars.

Target pacing is approximately:

- simple multi-stage project such as an early fire: 2–5 in-game days;
- complex project: 10–20 in-game days.

Most projects should eventually complete. Abandonment is possible but should not become the default. Abandoned projects may be dismantled and return resources.

Functional projects have priority when meaningful needs are unresolved. Decorative projects become more likely when Wilson is relatively comfortable or bored.

The intended technology ceiling is elaborate island survival: an improved shelter, functional furniture, tools and plausible island infrastructure. Wilson should not progress into implausible industrial technology such as rockets.

Most constructions are predefined project families. The shelter is a notable exception and may be partially modular using floor/wall/roof anchors and staged improvements.

The player never directly performs Wilson's construction work. Environmental intervention can provide/remove materials and, depending on mode, suggest relevant actions.

## Inventory and containers

Inventory is intentionally permissive and partially abstracted.

Objects may be classified as:

- abstractly carried/stored;
- visibly held in Wilson's hands, normally limited to two;
- transportable only through a container/carrier.

Containers increase carrying capacity without requiring physically perfect packing. A shovel in a bucket is acceptable if it keeps the simulation and animation tractable.

Wilson remembers the contents/location of containers he has explored. The player may alter an unexplored container, including determining its contents before Wilson opens it. Once Wilson has explored a container, its contents cannot be magically rewritten; the player may instead influence the world through normal object interactions.

## Humor and presentation

Humor may come from:

- physical slapstick;
- absurd objects;
- irony;
- timing and reaction animation;
- contradictions between stated intent and behavior;
- personality;
- running gags;
- dark humor.

Comedy is not protected from simulation consequences. A gag may cause injury or death.

The fourth wall is used sparingly and visually. Wilson may glance at the camera, tilt his head or make an ambiguous gesture. Explicit player-addressing dialogue is out of scope.

Animals never speak.

## Narrative layers

### Emergent behavior

Ordinary needs, affordances, memory and world state produce unscripted situations.

### Events

The world introduces a premise such as a crate washing ashore or an aircraft appearing.

### Directed scenes

Rare authored templates temporarily bias Wilson strongly toward a coherent sequence. They remain probabilistic.

Example:

```text
ship appears
  -> 40% run and wave
  -> 40% hide
  -> 10% alternative reaction
  -> 10% break directed scene and return to normal autonomy
```

The player never sees `directed scene started`. Some extreme interventions may be temporarily unavailable, but normal simulation can still break the expected scene.

Directed scenes do not need arbitrary player-created alternate endings. They need enough probabilistic branches and break conditions to preserve uncertainty.

Rare scenes may require explicit low probability plus unusual world/knowledge prerequisites. The game should not guarantee that every player sees every scene.

## World scope

The principal stage is a small tropical island. It remains the emotional and visual home throughout the run.

The world evolves at a deliberately limited systemic depth:

- vegetation grows;
- fruit falls and rots;
- the sea brings supported objects;
- weather changes priorities;
- structures/projects alter scenery.

Do not build an unnecessary full ecosystem simulation.

### Animals

One or two animals per run may become persistent recurring characters, such as a particular monkey. Other animals are episodic. Persistent animals can develop history with Wilson but are not domesticated or player-controlled.

### Other humans

Humans may appear in rare events but remain distant and lightly characterized: a pilot, sailor, passenger, etc. Avoid turning the island into a social settlement simulation.

### Additional areas

Initial candidates are:

- a small neighboring island;
- an abandoned wrecked/stranded ship.

Wilson and the camera travel to these areas. Access is rare, naturally time-limited and may disappear temporarily. Player intervention remains possible but more constrained than on the home island.

## Time and rhythm

An in-game day is currently targeted at approximately **15–20 real-time minutes** at normal speed, with roughly 70% daylight and 30% night.

World time is independent from real-world clock time.

Wilson usually sleeps through most of the night. Sleep is a long action. Special events may keep him awake for part or all of a night. Night has light ambient/content differences and some unique interactions, but is not a separate deep simulation.

The player may pause at any time. Time acceleration is available only while Wilson is sleeping and returns to normal automatically when he wakes.

## Offline simulation

Players choose whether the world pauses while closed or performs reduced offline simulation.

Offline simulation may:

- advance ordinary needs/state;
- progress projects partially;
- produce ordinary learning;
- change relationships/personality gradually;
- accumulate God Power up to a cap.

Offline simulation must not:

- kill Wilson;
- resolve major rare/directed scenes away from the player;
- unlock a new explorable area without the player;
- produce extreme irreversible surprises.

A rare/directed scene selected during catch-up may be deferred so its opportunity occurs after the player returns.

The desired return feeling is **"Let's see what happened"**, not anxiety about having left Wilson unattended.

## Diary and run history

The diary belongs to Wilson and contains only events he could know about. The authoritative layer stores structured facts; a future optional LLM layer may realize them as Wilson-flavored prose.

Important moments may also enter a per-run history/album, potentially with automatic screenshots. Candidates include rare events, major discoveries and project completion.

There is no global cross-run album requirement.

## Failure, death and resurrection

Wilson can die. Mortality may gradually increase later in a run through greater exposure to dangerous events/actions, helping long-lived worlds avoid indefinite stagnation.

Death should finish enough of the current visual sequence to feel coherent before presenting the player with a choice:

- resurrect Wilson;
- begin a new island/story.

There is no rewind/save-scumming feature in the intended experience.

Resurrection is free and does not make Wilson consciously remember death. It may nevertheless create:

- strong short-term fear;
- medium-term changes in curiosity/caution/faith;
- a long-lived negative association with the cause of death.

Simple visible passage-of-time markers such as beard growth, worn clothing and scars are desirable.

## UI philosophy

The default presentation is the world itself. UI should retreat when unused.

- God Power may remain as a small persistent indicator.
- Selecting Wilson may reveal need/status bars without exact numeric values.
- A secondary panel may expose more qualitative detail.
- Do not expose utility scores, hidden properties, directed-scene state or exact probabilities to normal players.
- Wilson's animation should communicate intention rather than a persistent textual `current plan` display.
- Speech/thought bubbles are sparse and may communicate acceptance/refusal of a suggestion.
- Small draggable objects may support physical drag-and-drop where placement rules remain understandable; large/static objects need not.

## Onboarding

There is no traditional tutorial sequence.

The opening intentionally lets Wilson act autonomously for roughly 1–2 minutes. At least one early exploration should be strongly encouraged by the simulation so the player understands that Wilson acts without commands.

The first simple object interaction, likely a coconut, may show a small contextual hint such as clicking for possibilities or dragging supported objects. If the player never interacts, the game should continue without tutorial interruption.

God Power is visible from the beginning.

## Meta-progression

Conquest is the recommended/main mode, but the two Sandbox modes remain legitimate ways to play.

Global meta-progression is deliberately light:

- simple lifetime statistics may exist;
- rare events witnessed may be recorded;
- specific experiences may unlock absurd/easter-egg objects in future runs.

Unlocked absurd objects simply become available in future runs rather than filling a visible completion catalog. They should be primarily comic/decorative, with only occasional modest functional usefulness.

Platform achievements are deferred.

## Open product questions

The following areas require deliberate follow-up rather than premature architecture decisions:

1. **Wilson psychology:** choose a minimal useful model for traits, motivation, emotion, memory, habits and risk behavior using relevant psychology/game-AI research.
2. **System vocabulary:** validate the first set of verbs, semantic roles, graded properties, discovery rules, transformations and affordances against concrete scenes.
3. **Content minimum:** determine the smallest object/project/animal/event/animation set that produces convincing 15–30 minute autonomous sessions.
4. **Contextual UX:** prototype click/submenu/drag/suggestion/insistence flows against real interaction examples.
5. **God Power economy:** calibrate generation, streaks, intervention costs, caps and progression without making intervention farming the primary game.
6. **Survival depth:** choose the minimum needs, hazards, injuries and weather consequences that create stories without becoming a survival-management game.
7. **Vertical-slice scope:** separate long-term product vision from the smallest slice that proves the experience.

## Scene-driven calibration method

Before committing to detailed data structures or balance, create a catalog of **desirable representative scenes**. Each scene should describe the player-visible story first, without assuming implementation.

For every scene, map which systems influence each beat, for example:

| Scene beat | World/objects | Knowledge | Needs/status | Traits/emotions | Memory/habits | Project | Event/director | Player/God Power | Expected variation |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Wilson notices strange object | object appears | unfamiliar type | curiosity | caution vs recklessness | prior divine interventions | — | event setup | player may have created it | inspect / flee / ignore |
| Wilson experiments | physical affordances | uncertain result | urgency limits curiosity | risk weighting | prior failures | — | normal autonomy | player may suggest | safe / absurd / refuse |
| Consequence occurs | transformation/effect | new relation learned | needs may change | emotion reaction | memory reinforced | may create new possibility | possible follow-up | new intervention opportunity | success / failure / gag |

Use these scenes as **requirements probes**. A proposed trait, status, property, memory field, God Power rule or interaction verb should justify itself by changing one or more desirable scenes in a useful and observable way.

The scene catalog can be prepared independently as a design handoff, then reviewed against the product principles before it is used to derive technical structure.

## Vertical-slice direction

The previous milestone remains intentionally smaller than the complete vision. It should prove:

- Wilson is entertaining without input for at least 15–30 minutes;
- early autonomy/onboarding works;
- several generic physical exploration verbs;
- at least one property-driven surprising interaction;
- learned interaction/discovery progression;
- contextual player suggestion with acceptance/refusal;
- a small God Power loop;
- one persistent instance relationship or memory;
- one short multi-day project represented visibly in the world;
- one ordinary event and one simple directed scene;
- day/night rhythm;
- save/load and safe offline catch-up;
- enough variation that repeated runs do not immediately converge on the same visible sequence.

Do not require the first slice to implement the full psychology model, large knowledge graph, additional areas, elaborate construction, LLM dialogue, broad meta-progression or a large content catalog.
