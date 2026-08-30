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

Wilson wakes, explores, eats, works on projects, reacts to weather, discovers objects, develops habits and changes his environment. A player may watch for minutes without doing anything, click a world object to reveal currently valid interactions, give Wilson advice, or alter something in the environment. Wilson may accept, refuse or reinterpret suggestions according to his personality and relationship with the player.

When the player returns after being away, elapsed time is simulated forward from the persisted state. The world should feel as though it continued to exist rather than restarting at the last visible frame.

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

| Document | Purpose |
| --- | --- |
| [`docs/PRODUCT.md`](docs/PRODUCT.md) | Product vision, player experience and scope |
| [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) | Runtime architecture, boundaries and data flow |
| [`docs/SIMULATION.md`](docs/SIMULATION.md) | World model, affordances, Utility AI, GOAP and procedural narrative |
| [`docs/VISUAL_GUIDE.md`](docs/VISUAL_GUIDE.md) | Visual language and art direction |
| [`docs/ASSET_PIPELINE.md`](docs/ASSET_PIPELINE.md) | Blender → validation → GLB → Godot pipeline |
| [`docs/ASSET_SPEC.md`](docs/ASSET_SPEC.md) | Machine-readable conventions for 3D assets, anchors and sockets |
| [`docs/AI.md`](docs/AI.md) | LLM responsibilities, contracts and safety boundaries |
| [`AGENTS.md`](AGENTS.md) | Repository-level instructions for coding and 3D agents |

## First milestone: the living diorama

Before building a broad game, prove the production pipeline with one vertical slice:

- one small tropical island;
- Wilson as a placeholder or first-pass character;
- orthographic gameplay camera;
- day/night and basic weather;
- palms, rocks, vegetation, a crate, campfire and simple shelter;
- navigation between interaction anchors;
- a small set of needs and autonomous activities;
- contextual player interactions;
- persistent state and offline catch-up;
- at least one multi-step goal solved through reusable actions;
- one Blender-generated modular asset family imported successfully into Godot.

The milestone succeeds when the scene is pleasant to leave fullscreen, Wilson visibly acts without player input, and the same systems produce more than one plausible sequence of events.

## Non-goals for the first milestone

Do not optimize for photorealism, a large map, multiplayer, a large handcrafted campaign, unrestricted LLM world generation, detailed survival simulation, or hundreds of unique animations. Depth should come from combinations, not raw content count.

## Status

Pre-production / architecture and visual-pipeline exploration.
