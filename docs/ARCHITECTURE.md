# Architecture

## Architectural goal

Wilson Shipwrecked is a **simulation rendered as a game**, not game scenes pretending to be a simulation. Authoritative world logic must remain testable without loading a 3D scene.

```text
Player input ───────────────┐
                           v
World State -> Decision Systems -> Action System -> World State
     ^             |                |
     |             |                +-> Scene/Animation intents
     |             +-> Utility AI / GOAP / Event Director
     |
Persistence <------+-------------------------------+
     |                                              |
     +-> offline catch-up                           v
                                             Presentation
                                             Godot 3D + UI
                                                   |
                                                   v
                                             optional LLM
                                      interpretation/narration only
```

## Layers

### Domain / simulation

Pure game-world concepts: entities, components/properties, needs, traits, relationships, goals, actions, effects, time, weather, resources, projects and memories. It must not depend on nodes, meshes, animation players or frame rate.

### Decision

Chooses *what* autonomous actors want and *how* they can pursue it.

- Utility AI ranks competing desires/goals.
- GOAP or an equivalent planner composes known actions into plans.
- Event Director introduces external opportunities/complications under explicit constraints.
- Narrative grammar can arrange compatible events into micro-arcs.

### Action

The only normal path for changing authoritative state. An action validates preconditions, reserves required resources/targets when needed, executes or advances, and applies typed effects. Player interactions and AI plans converge on the same action contracts.

### Presentation

Godot translates simulation intents into navigation, animation, sound, particles, camera and contextual UI. Presentation can lag, interpolate or dramatize an action but must not secretly create domain facts.

### Persistence

Stores schema-versioned authoritative state, RNG/seed information, timestamps and durable history. Loading performs migrations before simulation resumes.

### AI integration

Optional boundary service. The LLM receives a deliberately bounded projection of world state and returns structured proposals or interpreted intent. Returned data is schema-validated and then checked against simulation rules.

## Dependency rule

Dependencies point inward:

```text
Godot presentation -> application orchestration -> simulation domain
LLM adapter -------^                         persistence adapter -------^
```

The simulation must be runnable headlessly for tests and large batches of accelerated worlds.

## World representation

Prefer composition over inheritance. A world entity has identity plus data-driven capabilities/properties.

```text
Entity: coconut_tree_42
  transform: ...
  tags: [plant, woody, cuttable, climbable, fruit_source]
  resources: { wood: 4, coconut: 3 }
  state: { health: 0.92, wetness: 0.1 }
  anchors: supplied by presentation asset metadata
```

Domain logic should refer to semantic capabilities (`cuttable`, `container`, `cookable`) rather than concrete art assets (`palm_tree_03.glb`).

## Simulation time

Use simulation time, not rendering delta, as the source of truth. Support:

1. normal real-time ticks;
2. accelerated/headless ticks for testing;
3. offline catch-up from the last persisted timestamp.

Offline catch-up should use coarse event-aware stepping rather than replaying every rendered frame. Set an explicit maximum catch-up horizon if needed for performance and balance.

## Randomness

All simulation randomness must flow through a seeded RNG abstraction. Persist sufficient RNG state or deterministic seeds to reproduce defects. Visual-only randomness may be separate and must not affect gameplay state.

## Interaction flow

```text
player selects entity
  -> query affordances(world, actor?, entity)
  -> return currently valid interactions
  -> player chooses or expresses intent
  -> optional LLM intent parsing
  -> validate action request
  -> action system
  -> authoritative effects
  -> presentation intent
```

The UI must never contain its own duplicate rules for whether an interaction is legal.

## Scene architecture

Recommended Godot responsibilities:

```text
Main
├── WorldPresentation
│   ├── Terrain
│   ├── EntityViews
│   ├── Navigation
│   ├── Effects
│   └── LightingWeather
├── CharacterPresentation
├── CameraRig
├── InteractionUI
└── Application
```

Exact node layout may evolve. Domain IDs must be mapped to presentation nodes rather than inferred from scene-tree paths.

## Data-driven definitions

Definitions that designers/agents should be able to add without changing core algorithms include:

- entity archetypes;
- properties/tags;
- action definitions;
- affordance rules;
- item/material definitions;
- goal definitions;
- event templates;
- narrative templates;
- asset manifests.

Prefer typed Resources or validated JSON-like definitions depending on the eventual Godot implementation. Do not turn arbitrary strings into an implicit scripting language.

## Observability

Development builds should expose a debug inspector for:

- current simulation time and seed;
- Wilson's needs and traits;
- utility scores;
- active goal and plan;
- current action;
- available affordances for a selected entity;
- recent authoritative events;
- RNG/replay identifiers.

The player-facing build should hide this unless debug mode is enabled.

## Testing strategy

### Unit
Pure rules: preconditions, effects, utility calculations, planning predicates, serialization and migrations.

### Simulation
Run hundreds/thousands of accelerated worlds and inspect distributions: dead ends, repetitive loops, unreachable goals, resource collapse, event frequency and progression diversity.

### Integration
Godot scene ↔ domain IDs, anchor discovery, navigation to anchors, animation completion, save/load and GLB imports.

### Visual
Reference screenshots and human/vision-agent review for camera composition, silhouette readability, clipping, style consistency and interaction poses.

## Architecture invariants

- Rendering state is not authoritative game state.
- No LLM response directly mutates the world.
- No UI-specific rule determines domain legality.
- No simulation randomness bypasses the seeded RNG abstraction.
- Assets expose semantic attachment/interaction points instead of requiring object-specific coordinate hacks.
- A new compatible object should inherit existing interactions from properties whenever possible.
- A new story should preferably emerge from existing systems before a bespoke event is added.
