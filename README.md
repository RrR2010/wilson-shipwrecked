# Wilson Shipwrecked

An autonomous, persistent miniature world inspired by the ambient storytelling of classic screensavers and the attachment/progression of virtual pets.

Wilson lives in a stylized shipwrecked world that continues to evolve whether the player intervenes or simply watches. The player is neither Wilson's puppeteer nor a passive spectator: the world exposes contextual interactions, Wilson makes autonomous decisions, and both leave persistent consequences.

> **Design thesis:** build a vocabulary of combinable world rules rather than a large predefined story tree.

## Core principles

1. **Autonomy first** — Wilson has needs, traits, goals and plans of his own.
2. **Player agency without direct control** — the player can inspect, suggest, give, manipulate and interact whenever the current world state permits it.
3. **Systemic emergence** — stories should mostly emerge from entities, properties, affordances, actions, goals and consequences.
4. **Persistent consequences** — decisions modify the future possibility space rather than merely selecting the next scene.
5. **Ambient readability** — the experience should remain enjoyable as a fullscreen living diorama with little or no UI visible.
6. **Procedural reuse** — code, narrative and visual assets should favor small reusable primitives with high combinatorial value.
7. **Deterministic authority** — the simulation owns facts and state. An LLM may interpret, propose and narrate, but may not directly mutate authoritative world state.
8. **Web-friendly** — the target experience should be distributable as a lightweight web build without requiring a continuously running backend.

## Intended experience

Wilson wakes, explores, eats, rests, works on projects, reacts to weather, discovers objects, develops habits and changes his environment. A player may watch for minutes without doing anything, click a world object to reveal currently valid interactions, give Wilson advice, or alter something in the environment. Wilson may accept, refuse or reinterpret suggestions according to his personality and relationship with the player.

When the player returns after being away, elapsed time is simulated forward from persisted state. The world should feel as though it continued to exist rather than restarting at the last visible frame.

## Technology direction

- **Engine:** Godot, using a 3D world presented as a stylized orthographic 2.5D diorama.
- **3D authoring:** Blender.
- **Asset interchange:** glTF/GLB.
- **Visual style:** low-poly, chunky, readable, modular, texture-light, animation-friendly.
- **Simulation:** deterministic/semi-deterministic systems independent from rendering.
- **AI:** optional adapter for dialogue, interpretation and constrained procedural-content proposals.
- **Persistence:** local-first for the initial static/web version.

These are architectural defaults, not permission to couple simulation logic to Godot rendering APIs.

## Documentation

Start with [`docs/README.md`](docs/README.md). It separates canonical contracts, specialized appendices, validation evidence and historical material, and provides task-specific reading paths.

Key entry points:

| Area | Entry point |
| --- | --- |
| Current phase / validated baseline | [`docs/DISCOVERY_STATUS.md`](docs/DISCOVERY_STATUS.md) |
| Active runtime handoff | [`docs/handoffs/observable-living-simulation-to-entertaining-systemic-diorama.md`](docs/handoffs/observable-living-simulation-to-entertaining-systemic-diorama.md) |
| Product / player experience | [`docs/PRODUCT.md`](docs/PRODUCT.md) |
| Wilson behavior | [`docs/BEHAVIORAL_MODEL.md`](docs/BEHAVIORAL_MODEL.md) |
| Architecture | [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) |
| Simulation orchestration | [`docs/SIMULATION_ORCHESTRATION.md`](docs/SIMULATION_ORCHESTRATION.md) |
| Functional domain | [`docs/DOMAIN_MODEL.md`](docs/DOMAIN_MODEL.md) |
| Cross-cutting modeled content | [`docs/asset-catalog/README.md`](docs/asset-catalog/README.md) |
| Visual production | [`docs/art/README.md`](docs/art/README.md) |
| Asset runtime/pipeline | [`docs/ASSET_SPEC.md`](docs/ASSET_SPEC.md), [`docs/ASSET_PIPELINE.md`](docs/ASSET_PIPELINE.md) |
| Agent repository rules | [`AGENTS.md`](AGENTS.md) |

## Current living-diorama baseline

The repository now has a continuously running Godot calibration scene using the real simulation/runtime boundaries:

```text
tools/living_simulation/living_simulation.tscn
```

The validated scene currently demonstrates a small but coherent autonomous island loop with:

- hunger and food seeking;
- energy and rest;
- stimulation and exploration;
- persistent shelter construction with interruption/continuation;
- recurring weather and tactical rain sheltering;
- Gerald as an independently moving shallow actor;
- primitive-shape world readability;
- compact operator observability;
- 1x / 4x / 16x time controls.

The structural/runtime foundation and this first observable-living-simulation milestone are complete.

## Current focus: from functioning to entertaining

The leading work is no longer another foundation proof. It is to make the living island produce more varied, understandable and memorable situations from the systems already present.

Current pressure includes:

- reduce inert idle through bounded Stimulation/boredom pressure rather than random behavior;
- give Gerald at least one Wilson-visible consequence instead of only waypoint movement;
- make a learned belief/association/habit visibly alter a later choice;
- give completed projects more life after completion where existing environment/protection systems support it;
- preserve compact causal readability while adding behavioral richness.

See the active handoff for the exact next-stage acceptance criteria.

## Non-goals

Do not optimize for photorealism, a large handcrafted campaign, unrestricted LLM world generation, detailed survival simulation, multiplayer, or content breadth for its own sake. Depth should come from reusable interactions and persistent consequences.

## Status

Current implementation checkpoint, strict test count, schema versions, known limitations and calibration pressures are maintained in [`docs/DISCOVERY_STATUS.md`](docs/DISCOVERY_STATUS.md).
