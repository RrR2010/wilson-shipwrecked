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
8. **Progression is open-ended.** There is no hidden campaign or escape objective. Long-lived runs become richer through accumulated world state, knowledge, habits, relationships, projects and increasingly broad eligible possibilities.
9. **Comedy is systemic.** Slapstick, absurdity, irony, contradiction, timing and running gags may all have real simulation consequences.

## Wilson identity

Wilson is **the Wilson**, not a fully randomized protagonist. Each run preserves a recognizable base personality while allowing modest randomized variation and progressive shaping through learned state.

Wilson:

- knows his own name but has no required pre-island biography;
- begins as a competent adult with basic everyday and survival knowledge;
- occasionally makes unexplained jokes suggesting that he may once have believed he was a ball;
- never receives a canonical explanation for that belief;
- can develop preferences, habits, fears, relationships and changing learned behavior;
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
- indirectly prevent dangerous actions by changing the environment;
- create dangerous or lethal grounded consequences when a supported intervention permits it.

The player may not:

- directly move Wilson;
- remove an object from Wilson's hands;
- force an animation/action already underway to stop;
- remove Wilson's autonomy, including in Sandbox modes.

A valid player intervention is not rejected merely because its grounded consequence may injure or kill Wilson. The world resolves the intervention normally.

Wilson reacts only from what he can perceive and infer. A player action has no direct psychological effect merely because the player intended to help or harm. An object appearing nearby may cause surprise, fear, flight, investigation or eventual habituation depending on Wilson's awareness, attribution, current state and history with the player.

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

God Power balance and player capability are separate concerns. Accumulating more God Power does **not** unlock new intervention powers; it only allows the player to perform more or larger already-available interventions before recharging.

Player-side intervention affordances are explicitly supported by the affected object/environment capability. Having enough God Power does not make every world entity manipulable. For example, portable resources such as stones, coconuts or wood may support drag-and-drop while structures, fires or large assembled constructions may expose no direct drag affordance.

Resurrection is always available and does not require God Power.

## Luck and chance favorability

Wilson may have an effective **Luck** value used only where the simulation explicitly contains chance-sensitive alternatives.

Luck is **not** a psychological trait, drive or knowledge value. Its intended semantics are:

```text
luck > neutral  → chance-sensitive outcomes tend to resolve more favorably for Wilson
luck < neutral  → chance-sensitive outcomes tend to resolve less favorably for Wilson
```

The preferred model is a neutral Wilson baseline plus bounded active modifiers supplied by world/content state, for example a carried amulet, a temporary event effect or another contextual condition. The effective value may therefore be derived rather than stored as an independently drifting Wilson stat.

Luck must not override established causality. It may choose among genuinely plausible random alternatives, bias a luck-sensitive event variant or influence an uncertain incidental circumstance; it must not make an impossible action succeed, undo committed physics or rewrite an already-grounded consequence.

Luck also does **not** control how many rare events occur. Event rarity/frequency remains a Director/opportunity concern. The design intentionally does not introduce a separate persistent `chaoticity` stat.

Wilson has no privileged access to the effective Luck value. He only observes outcomes and may form ordinary causal beliefs or superstitions about objects/events through the existing belief/attribution model. Such a belief may be correct or incorrect.

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

A learned interaction is not a handcrafted object-pair recipe. It is Wilson's semantic knowledge that a reusable property/capability relationship produces a useful result.

### Contextual selection

The initiating object determines which exploration verbs are available. A throwable coconut can expose `Throw at...` and list nearby targets, including useless ones. Clicking a wall does not need to enumerate every throwable object that could be thrown at it.

This intentionally permits bounded brute-force experimentation and absurd combinations while keeping the interaction space manageable.

Wilson may still refuse a physically valid suggestion because of risk, urgency, preference, memory or autonomy.

Suggestions for learned interactions are limited to Wilson's knowledge. Physical exploration suggestions may be available before either Wilson or the player knows their outcome, provided the required participants and context are locally available.

If a known interaction requires a missing participant, do not show the unavailable interaction. A separate contextual suggestion such as `Search for...` may let the player encourage Wilson to locate the missing resource first.

## Knowledge and discovery

Progression is a **knowledge graph**, not a conventional technology tree and not a visible recipe catalog.

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

Interaction possibility should normally be defined by reusable **requirements over properties, capabilities, roles and context**, rather than enumerated source-object recipes.

For example, do not model coconut opening primarily as:

```text
stone + coconut -> opened_coconut
```

Model the reusable relationship conceptually as something closer to:

```text
impact action
+ tool with sufficient impact/hardness capability
+ target with compatible breakability/resistance
+ valid spatial/action context
-> target transformation when thresholds are satisfied
```

A stone, hammer or another sufficiently capable object can therefore satisfy the same interaction without a separate recipe entry for every pair.

### Eligibility and discovery

Content may define semantic requirements that determine when an exploration, interaction, project or hidden possibility becomes eligible. Requirements may include knowledge, capabilities, world conditions, proximity, object properties, environmental state or other authored semantic predicates.

Satisfying those requirements does not grant Wilson hidden omniscient knowledge. It makes the corresponding **exploration opportunity** available when the situation is encountered.

There is no separate random discovery roll once Wilson is actually exposed to an eligible observable result. If Wilson performs or encounters the relevant interaction and observes the meaningful result, the resulting knowledge is acquired according to its discovery semantics.

This allows secrets to remain undiscovered for a long time because their conjunction of prerequisites is rare rather than because the game withholds an already-observed result behind RNG.

Hints should normally be diegetic world content rather than a recipe UI. A bottle arriving with a suggestive message, an environmental clue or another authored event may encourage a useful experiment without revealing hidden internal requirements.

### Wilson and player knowledge

Wilson does not magically know authoritative object properties. Exploration can reveal properties or specific interactions depending on direction and result.

Example:

```text
coconut -> hit with -> stone
  may teach properties of the coconut

stone -> hit -> coconut
  may teach properties/capabilities of the stone
```

The normal player-facing rule is that **the player learns Wilson's semantic interaction knowledge when Wilson learns it**. The UI must not reveal unknown semantic interactions, hidden properties or unmet discovery requirements merely because the content exists in data.

The player may still suggest generic physical exploration before a result is known, using only currently available exploration affordances.

Knowledge can have confidence. Repeated success can reinforce confidence; failure can reduce it or establish a negative expectation.

Properties may define different discovery behavior, for example:

- universal/basic knowledge;
- discover once and generalize;
- discover per object type.

Object categories may produce expectations before confirmation. Wilson may reasonably assume that an unfamiliar stone-like object is hard and then be surprised when pumice behaves differently.

Basic learned interactions are generally persistent within a run. Contextual and emotional memories may decay.

## Properties and systemic reuse

Prefer reusable graded properties, capabilities and thresholds over hardcoded object-pair recipes.

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

Content authors define reusable properties, capabilities, role requirements, contextual predicates and supported transformations. The simulation composes matching participants at runtime. Authoring a transformation target such as `opened_coconut` does not imply authoring a list of every source tool that can produce it.

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

The exact ownership of memory between Wilson and entity metadata is defined by the later behavioral/architecture documents; product behavior requires instance-specific history without duplicating authoritative ownership.

## Wilson behavioral core

The canonical Wilson model is defined by `BEHAVIORAL_MODEL.md` and `STATE_REQUIREMENTS.md`. Product behavior currently relies on the following compact core.

### Stable run traits

```text
curiosity
risk_tolerance
independence
```

These are stable disposition modifiers rather than goals or continuously self-correcting values.

### Core drives

```text
hunger
energy
comfort
stimulation
```

These produce changing motivational pressure. There is no separate accumulating safety, loneliness or fun drive.

### Persistent learned/personal state

Wilson may accumulate:

- beliefs/knowledge with scope/confidence where relevant;
- associations with independent valence and attachment;
- selected episodic history;
- habits;
- current and suspended intentions;
- projects and project-related history;
- a relationship with the unseen presence represented by `presence_belief`, `trust` and `dependency`.

### Transient reactions

Fear, anger, joy/excitement, surprise/orient, frustration, relief and similar scene reactions are primarily short-lived derived consequences. Durable effects consolidate into beliefs, associations, habits, episodes or relationship state rather than long-lived global mood bars.

### Explicitly not separate canonical psychology

Do not reintroduce old provisional product concepts as independent primitives unless new regression evidence requires them:

```text
sanity
sociability
loneliness
caution/recklessness separate from risk_tolerance
faith separate from presence_belief
playfulness
persistence
forgiveness
regret
routine
tradition
global mood
```

Visible social, cautious, ritualistic, playful or regret-like behavior should compose from the admitted state where possible.

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

Functional projects have priority when meaningful needs are unresolved. Decorative projects become more likely when Wilson is relatively comfortable or under-stimulated.

The intended technology ceiling is elaborate island survival: an improved shelter, functional furniture, tools and plausible island infrastructure. Wilson should not progress into implausible industrial technology such as rockets.

Most constructions are predefined project families. The shelter is a notable exception and may be partially modular using floor/wall/roof anchors and staged improvements. Project form may be authored while material compatibility and many contribution interactions remain property/capability-driven rather than recipe-pair-driven.

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

The intended rhythm is **nearly contemplative rather than constantly eventful**. Long stretches of ordinary life are valid play, but a normal active day should usually contain at least some visible evolution, amusing situation, discovery, complication, project development or other meaningful change.

Rare-event opportunity may increase gradually after unusually quiet periods and decrease while several meaningful consequences/events are already active. This is a bounded pacing pressure on opportunity generation, not a separate psychological drive, guaranteed pity timer, visible meter or permission to force authored scenes.

Wilson usually sleeps through most of the night. Sleep is a long action. Special events may keep him awake for part or all of a night. Night has light ambient/content differences and some unique interactions, but is not a separate deep simulation.

The player may pause at any time. Time acceleration is available only while Wilson is sleeping and returns to normal automatically when he wakes.

## Offline simulation

Players choose whether the world pauses while closed or performs reduced offline simulation.

Offline simulation may:

- advance ordinary needs/state;
- progress projects partially;
- produce ordinary learning;
- change relationships/personality gradually where current canonical rules allow;
- accumulate God Power up to a cap.

Offline simulation must not:

- kill Wilson;
- resolve major rare/directed scenes away from the player;
- unlock a new explorable area without the player;
- produce extreme irreversible surprises.

A rare/directed scene selected during catch-up may be deferred so its opportunity occurs after the player returns.

The desired return feeling is **"Let's see what happened"**, not anxiety about having left Wilson unattended.

## Diary and history

There is one player-facing **Diary** surface rather than separate diary, album and statistics products.

The current-run narrative portion remains Wilson-grounded: descriptive entries about the active run contain only events Wilson could know about. The authoritative layer stores structured facts; a future optional LLM layer may realize them as Wilson-flavored prose.

The Diary may also contain clearly player-level archival information that is not asserted as Wilson memory, including:

- current-run and lifetime statistics;
- a chronological history of important run milestones and discoveries;
- selected rare-event records;
- automatic screenshots for supported rare or important moments;
- project/construction achievements and other meaningful accomplishments;
- archived summaries of completed runs.

When the player ends a run, the world stops permanently and its selected history is archived into this same Diary. A concise progression summary may include entries such as `day 2: made fire` or `day 5: completed shelter improvement` before the player begins a new island.

The Diary is therefore one UI/product surface containing both Wilson-grounded run narrative and explicitly player-level historical/statistical records. These information classes must remain semantically distinguishable even when shown together.

## Failure, death and resurrection

Wilson can die. Mortality may gradually increase later in a run through greater bounded exposure to dangerous or unusual opportunities, helping long-lived worlds avoid indefinite stagnation. This must not become level scaling or a hidden rule that invalidates grounded causal outcomes.

Death should finish enough of the current visual sequence to feel coherent before presenting the player with a choice:

- resurrect Wilson;
- end the current run and begin a new island/story.

Resurrection is free, always available and unlimited within a run. There is no life counter and repeated resurrection does not acquire an artificial escalating resurrection penalty.

There is no rewind/save-scumming feature in the intended experience.

Resurrection does not make Wilson consciously remember death. It may nevertheless create:

- strong short-term fear;
- short-term bodily/status normalization or reaction appropriate to the resurrection presentation;
- medium-term behavioral caution derived from learned danger;
- a long-lived negative association or danger belief tied to the object, actor, action or cause of death.

The durable consequence should be expressed through ordinary beliefs/associations and future caution rather than a dedicated `died_before` psychological primitive.

Choosing **End Run** permanently closes that island/world. The Diary retains the selected history, statistics, screenshots, achievements and run summary described above, plus any cross-run progression explicitly admitted below.

Simple visible passage-of-time markers such as beard growth, worn clothing and scars are desirable.

## UI philosophy

The default presentation is the world itself. UI should retreat when unused.

- God Power may remain as a small persistent indicator.
- Selecting Wilson may reveal need/status bars without exact numeric values.
- A secondary panel may expose more qualitative detail.
- Do not expose utility scores, hidden properties, directed-scene state, unmet discovery requirements or exact probabilities to normal players.
- Wilson's animation should communicate intention rather than a persistent textual `current plan` display.
- Speech/thought bubbles are sparse and may communicate acceptance/refusal of a suggestion.
- Small draggable objects may support physical drag-and-drop where placement rules remain understandable; large/static objects need not.

## Onboarding

There is no traditional tutorial sequence.

The opening intentionally lets Wilson act autonomously for roughly 1–2 minutes. At least one early exploration should be strongly encouraged by the simulation so the player understands that Wilson acts without commands.

The first simple object interaction, likely a coconut, may show a small contextual hint such as clicking for possibilities or dragging supported objects. If the player never interacts, the game should continue without tutorial interruption.

God Power is visible from the beginning.

## Meta-progression and Legacy Knowledge

Conquest is the recommended/main mode, but the two Sandbox modes remain legitimate ways to play.

Global meta-progression is deliberately light and must not become a technology tree or visible recipe-completion checklist.

The global layer may retain:

- lifetime statistics;
- selected rare events witnessed;
- achievements/important milestones and supported screenshots through the Diary;
- specific absurd/easter-egg object unlocks where intentionally authored;
- a small amount of **Legacy Knowledge** selected when a run ends.

### Legacy Knowledge

Legacy Knowledge is cross-run operational interaction knowledge, not autobiographical memory.

Only knowledge explicitly marked as eligible may carry across runs. Eligible knowledge has authored weighting/probability used when selecting the small subset preserved at run end. Exact selection count and weighting formula are balance decisions.

A new Wilson seeded with Legacy Knowledge behaves as if the corresponding interaction relationship is already known. For example, if `cook food using fire` is preserved, the new Wilson does not need to rediscover it by placing raw meat near a fire first.

Legacy Knowledge does **not** preserve:

- memories of the previous island;
- episodes or screenshots as Wilson memory;
- previous relationships or object instances;
- the fact that Wilson learned the knowledge in another run;
- the fact that Wilson died.

The player may erase Legacy Knowledge/global progression and return to a clean progression state.

Unlocked absurd objects simply become available in future runs rather than filling a visible completion catalog. They should be primarily comic/decorative, with only occasional modest functional usefulness.

Platform achievements are deferred.

## Open product questions

The remaining questions should be resolved primarily through implementation and playtesting rather than a new broad discovery phase:

1. **Content minimum:** determine the smallest object/project/animal/event/animation set that produces convincing 15–30 minute autonomous sessions.
2. **Contextual UX:** prototype click/submenu/drag/suggestion/insistence flows against real interaction examples.
3. **God Power calibration:** tune generation, streaks, intervention costs and cap without making intervention farming the primary game.
4. **Luck calibration:** define the bounded Luck range, modifier composition and which opportunity/outcome classes are explicitly luck-sensitive.
5. **Survival calibration:** tune hazards, injuries, bodily pressures and long-run mortality exposure without turning the game into a survival-management or level-scaling system.
6. **Discovery vocabulary:** validate the initial property/capability requirements, transformation rules and generic exploration verbs against the first concrete content set.
7. **Legacy calibration:** determine eligible knowledge weights and how much Legacy Knowledge should normally survive a completed run.

## Scene-driven calibration method

Before committing to detailed balance, use the catalog of **desirable representative scenes** as requirements and regression probes. Each scene describes the player-visible story first, without assuming a special implementation path.

For every scene, map which systems influence each beat, for example:

| Scene beat | World/objects | Knowledge | Needs/status | Traits/emotions | Memory/habits | Project | Event/director | Player/God Power | Expected variation |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Wilson notices strange object | object appears | unfamiliar type | curiosity | risk tolerance / current danger beliefs | prior divine interventions | — | event setup | player may have created it | inspect / flee / ignore |
| Wilson experiments | physical affordances | uncertain result | urgency limits curiosity | risk weighting | prior failures | — | normal autonomy | player may suggest | safe / absurd / refuse |
| Consequence occurs | transformation/effect | new relation learned | needs may change | transient reaction | memory reinforced | may create new possibility | possible follow-up | new intervention opportunity | success / failure / gag |

Use these scenes as **requirements probes**. A proposed trait, status, property, memory field, God Power rule or interaction verb should justify itself by changing one or more desirable scenes in a useful and observable way.

## Vertical-slice direction

The first implementation slice remains intentionally smaller than the complete vision. It should prove:

- Wilson is entertaining without input for at least 15–30 minutes;
- early autonomy/onboarding works;
- several generic physical exploration verbs;
- at least one property-driven surprising interaction;
- property/capability-driven transformation without an object-pair recipe catalog;
- learned interaction/discovery progression;
- contextual player suggestion with acceptance/refusal;
- a small God Power loop;
- one persistent instance relationship or memory;
- one short multi-day project represented visibly in the world;
- one ordinary event and one simple directed scene;
- day/night rhythm;
- save/load and safe offline catch-up;
- enough variation that repeated runs do not immediately converge on the same visible sequence.

Do not require the first slice to implement a large knowledge graph, additional areas, elaborate construction, LLM dialogue, broad meta-progression or a large content catalog.
