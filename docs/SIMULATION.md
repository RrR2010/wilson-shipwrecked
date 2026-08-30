# Simulation Design

## Principle

The simulation should generate situations from reusable rules. Do not encode the future as a large branching story tree.

## Core vocabulary

```text
Entity + Properties + State
          |
          v
      Affordances
          |
          v
        Actions
          |
          v
        Effects
          |
          v
      World State
```

### Entity
A stable identity in the world: Wilson, a tree, crate, fish, shelter, tool, resource pile, etc.

### Property / capability
Semantic facts enabling generic rules: `cuttable`, `edible`, `flammable`, `container`, `floating`, `climbable`, `cookable`, `binding`, `cutting_tool`.

### State
Mutable values such as health, wetness, temperature, quantity, open/closed, burning, cooked/raw, location and ownership.

### Affordance
A currently available interaction derived from world state. It describes *what can be attempted*, not a hardcoded UI button.

### Action
A reusable state transition with typed preconditions, costs/duration and effects.

## Example generic action

```text
CUT(actor, tool, target)

requires:
  tool: cutting_tool
  target: cuttable
  actor can reach target

effects:
  target durability decreases
  actor energy decreases
  material may be produced at threshold
```

The same action can apply to a vine, tree, rope or wooden crate when their capabilities permit it.

## Affordance discovery

Affordances are queried at runtime. Presentation asks the domain for valid interactions and renders those results. Typical sources:

1. target properties;
2. actor inventory/capabilities;
3. spatial reachability;
4. Wilson/player knowledge;
5. current action/reservations;
6. environmental conditions;
7. relationship/permission constraints.

## Utility AI

Utility chooses which goal deserves attention. Keep scoring inspectable and data-driven.

Example candidates:

```text
eat                 0.86
seek_shelter        0.74
investigate_crate   0.63
continue_raft       0.42
rest                 0.18
```

Scores may combine need urgency, personality, memories, risk, novelty and player suggestions. Avoid opaque monolithic formulas; expose score components in debug mode.

## Planning / GOAP

Planning answers how to reach a desired world predicate using generic actions.

```text
goal: hunger < threshold
inventory.food = false

possible plan:
  acquire fishing tool
  -> navigate to fishing anchor
  -> fish
  -> create/locate fire
  -> cook
  -> eat
```

Plans must be interruptible when assumptions become invalid or a much higher-priority goal appears.

## Projects

Long-running goals should be represented as persistent projects rather than bespoke scenes. A project defines desired capabilities/state and may accept multiple material solutions.

Prefer functional requirements:

```text
raft requires:
  buoyancy >= X
  stability >= Y
  binding_strength >= Z
```

over one mandatory recipe when practical. This permits logs + vine, barrels + rope, crates + vine, etc., with different resulting qualities.

## Event Director

External events introduce novelty but remain constrained by the world model.

An event template should define:

- eligibility conditions;
- cooldown/frequency/rarity;
- required spawn/location capabilities;
- parameter slots;
- authoritative effects/actions;
- presentation hints;
- follow-up hooks.

Example template:

```text
ARRIVAL(object, location)
requires location: arrival_surface
object pool constrained by world/theme/progression
```

This can yield a bottle, debris, crate, animal or other supported entity without creating separate event code for each combination.

## Narrative grammar

Micro-stories may be assembled from semantic roles:

```text
SETUP -> CURIOSITY -> ATTEMPT -> COMPLICATION -> CONSEQUENCE
```

A role is filled only by events whose pre/postconditions connect coherently. Narrative grammar does not bypass simulation rules.

## LLM-generated proposals

The LLM may propose parameters or a supported template, for example:

```json
{
  "template": "resource_discovery",
  "location": "cave_1",
  "entity_archetype": "mushroom",
  "suggested_traits": ["edible", "unknown_to_wilson"]
}
```

The engine resolves IDs, validates allowed properties and feasibility, then accepts, modifies or rejects the proposal. Never execute arbitrary effects from generated text.

## Knowledge separation

Maintain distinct concepts:

- **world truth:** authoritative facts;
- **Wilson knowledge:** what Wilson believes/knows;
- **player knowledge:** what has been revealed to the player;
- **LLM context:** a bounded projection assembled for one request.

This allows discovery, uncertainty and mistaken expectations without corrupting authoritative state.

## Memory

Memories are structured and compact, e.g. actor, event type, subjects, valence, importance, timestamp and optional semantic tags. Low-importance memories may decay. Important memories can affect utility and be summarized for dialogue.

## Offline catch-up

On load:

1. read saved simulation timestamp;
2. calculate elapsed wall time under configured limits;
3. advance simulation using coarse/event-aware steps;
4. resolve events and decisions deterministically;
5. produce a concise catch-up event log;
6. present only noteworthy outcomes to the player.

Do not make LLM availability a prerequisite for catch-up.

## Procedural world generation

Use a reproducible seed and separate generation stages:

```text
seed
 -> macro terrain / coastline / elevation
 -> biome/environment fields
 -> gameplay landmarks
 -> resource constraints
 -> object clusters
 -> decorative scatter
 -> visual variants
```

Gameplay-critical generation must validate reachability and minimum resource constraints. Decorative generation must not accidentally alter simulation state.

## Anti-repetition mechanisms

Use several modest mechanisms rather than uncontrolled randomness:

- cooldowns and recent-event penalties;
- novelty utility;
- personality weighting;
- state-dependent event pools;
- long-lived projects;
- seasonal/weather variation;
- resource ecology;
- memory-driven preferences;
- parameterized event templates;
- rare conjunction-based events.

## Balance through simulation

Provide a headless runner capable of thousands of simulated days/worlds. Track at least:

- goal/action frequencies;
- resource abundance/collapse;
- idle time;
- repeated loops;
- failed/replanned plans;
- project completion times;
- event-template coverage;
- unreachable states;
- diversity between seeds.

A procedural system that technically has millions of combinations but repeatedly converges on the same visible behavior is not diverse enough.
