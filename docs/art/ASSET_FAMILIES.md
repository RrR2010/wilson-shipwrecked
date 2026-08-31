# Initial Asset Families

## Purpose

This is a production-oriented taxonomy, not a complete gameplay content database.

It translates the first living-diorama milestone and representative-scene catalog into reusable **visual families**. Gameplay capabilities remain owned by simulation/domain definitions.

Priority levels:

- **P0** — required to establish the golden scene / first pipeline experiment;
- **P1** — high-value additions that unlock multiple representative scenes;
- **P2** — later breadth and rare-event support.

## Environment

### P0 — terrain island family

Parts / variants:

- sand patch / beach edge;
- grass/soil patch;
- low cliff mass;
- shoreline rock transition;
- small elevation mound.

States / material variants:

- dry;
- wet;
- worn/path-like.

Notes:

Use broad modular masses. Avoid texture-driven terrain complexity.

### P0 — rock family

Variants:

- `rock_small_throwable`;
- `rock_medium`;
- `rock_large_landmark`;
- `rock_flat_sitting`;
- 2–3 modular formation pieces.

States:

- dry;
- wet;
- optional moss/vegetation attachment variant.

Representative-scene value:

- sitting preference;
- tool experimentation;
- route landmarks;
- tide-pool composition;
- campfire ring composition.

### P0 — palm family

Modular parts:

- trunk variants;
- crown variants;
- coconut cluster;
- optional dry frond attachment.

States:

- healthy;
- depleted/no fruit;
- damaged;
- stump.

Required visual behavior:

- large readable crown silhouette;
- aggressive low-poly trunk segmentation;
- few broad fronds rather than many thin leaflets.

### P0 — tropical ground vegetation

Families:

- broad-leaf cluster;
- small fern-like cluster;
- edge/background dense cluster;
- sparse beach sprout.

Variation comes from part selection, scale and rotation, not vertex noise.

### P1 — tide-pool family

Parts:

- shallow water patch;
- enclosing rock modules;
- sand/rock transition;
- optional small aquatic vegetation.

Must support clear visual distinction from open ocean.

## Water

### P0 — ocean / shoreline presentation

Visual states:

- calm daylight;
- dusk/night color state;
- storm/rain state.

Keep the base geometry/material solution simple enough for web use. Low-frequency wave motion is preferable to dense geometric detail.

## Camp structures

### P0 — primitive shelter family

Modular parts:

- structural pole/log;
- ridge beam;
- roof/thatch panel;
- optional side panel;
- ground/sleeping mat.

States:

- construction frame;
- complete;
- damaged/missing panel;
- repaired/mismatched panel.

The silhouette must communicate improvisation through assembly geometry.

### P0 — campfire family

Parts:

- simplified stone ring;
- wood/fuel cluster;
- flame presentation object/effect;
- cooking support/tripod as optional assembly.

States:

- unlit;
- embers;
- lit;
- wet/extinguished.

### P0 — work surface family

Variants:

- crude table;
- simple workbench.

Construction from reusable planks/logs. Must remain visually simple.

### P0 — seating family

Variants:

- crude stool;
- log seat;
- environmental flat-rock seat uses rock family.

This family is important for habit/preference scenes despite low survival importance.

### P1 — storage family

Variants:

- wooden crate;
- crude storage chest/rack;
- bucket/basket-like open storage.

States:

- closed/open where relevant;
- empty/partially full/full presentation where feasible;
- damaged.

## Natural resources and common props

### P0 — coconut family

States:

- whole;
- cracked;
- opened halves;
- optional husk/remnant.

Make deliberately oversized enough for gameplay readability.

### P0 — wood resource family

Variants:

- branch/stick;
- short log;
- long log;
- plank;
- broken piece;
- carry bundle composition.

This should become a foundational generator family reused by structures and projects.

### P0 — generic stone resource

Use a distinct small/throwable member of the rock grammar rather than a visually unrelated family.

### P1 — fruit / food primitives

Start with a small reusable set of chunky food silhouettes rather than many detailed species.

### P1 — rope/fiber bindings

Shared construction primitives for shelter, raft and improvised projects.

## Manufactured debris

### P0 — wooden crate

A clean manufactured contrast against handmade camp construction.

Potential anchors:

- approach;
- pickup if size/state permits;
- inspect;
- open.

### P1 — sealed metal container

States:

- intact;
- dented;
- opened;
- badly damaged.

The family should visibly support the `Scientific Method` representative scene through large deformation states, not tiny texture scratches.

### P1 — generic metal debris

A few reusable forms:

- panel;
- canister;
- pipe/rod;
- scrap piece.

Avoid building many unique wreck fragments before gameplay proves the need.

### P2 — rare absurd object family

Examples may include bowling ball and other improbable washed-ashore objects.

Rare objects can use stronger individual silhouettes but must still obey project materials, scale and camera readability.

## Fauna

### P1 — crab family

Variants may primarily use size/palette differences.

Requirements:

- oversized claws/body relative to realism for readability;
- clear idle/move/threat silhouettes;
- simple topology suitable for lightweight animation;
- visually readable at tide-pool/beach distance.

### P2 — bird family

Start from one flexible tropical/seabird archetype before species proliferation.

## Projects / transport

### P1 — raft family

Modular composition from the same log/plank/rope grammar used elsewhere.

States:

- partial frame;
- assembled;
- damaged.

### P1 — generic project-frame primitives

Provide reusable visible construction-state pieces so multi-step projects can accumulate physical progress without bespoke art for every stage.

## Wilson

### P0 — Wilson prototype / mannequin

First goal is scale, silhouette and interaction validation, not final identity.

Required:

- adult human caricature;
- readable head/hands;
- less harshly faceted than environment;
- neutral base clothing;
- no strong `Don't Starve`-like gothic exaggeration;
- semantic hand/back/carry/head attachment anchors.

### Later — production Wilson

Requires explicit character review before lock:

- approved concept sheet;
- final proportions;
- topology/rig;
- facial-expression strategy;
- reusable animation library;
- clothing/accessory modularity decisions.

## Golden-scene minimum set

A first approved style-validation scene should contain at least:

```text
terrain island / beach
shoreline water
1 large cliff/rock mass
2–3 rock-family variants
2 palm variants
2–3 ground-vegetation clusters
primitive shelter
campfire
crude table/workbench
stool
crate
coconuts
wood resources
Wilson mannequin/prototype
```

This set is intentionally small. It should be visually approved before the repository receives broad asset production.

## Family brief template

Each family should eventually receive a brief containing:

```text
family ID
priority
visual role
gameplay scale
silhouette requirements
modular parts
required states
required anchors/sockets
allowed palette variants
triangle guardrail
procedural parameters
reference images
golden-scene comparison assets
acceptance checklist
```

Family briefs should reference `ASSET_SPEC.md` rather than duplicating structural contracts.
