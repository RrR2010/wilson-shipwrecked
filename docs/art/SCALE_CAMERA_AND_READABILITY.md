# Scale, Camera and Readability

## Coordinate baseline

Preserve the canonical asset contract:

- 1 Blender unit = 1 meter;
- placeable asset origin at sensible ground contact;
- transforms normalized before export where appropriate.

This file adds visual-production guidance on top of those rules.

## Canonical gameplay camera

Use an orthographic 3/4 camera as the primary review camera.

Until production calibration locks exact numbers, target approximately:

- elevation: 32–38 degrees;
- azimuth: a diagonal 3/4 view rather than strict side/front;
- minimal perspective distortion;
- enough visible horizon/water context to read island geography when composition allows;
- stable framing suitable for ambient fullscreen observation.

Do not optimize assets primarily for eye-level closeups or turntables.

## Camera philosophy

The camera should make the game feel like observing a miniature living scene rather than inhabiting Wilson's eyes.

Important consequences:

- top surfaces matter;
- silhouette overlap must be managed from above;
- interaction props need readable footprints;
- vegetation must not routinely obscure Wilson;
- shelters should communicate interior/opening direction from the gameplay angle;
- object orientation should read without relying on tiny labels.

## Character scale reference

Exact Wilson production height should be locked after character prototype. Until then, use an adult mannequin near **1.65–1.80 m** as a scale reference.

Do not infer prop scale from concept images alone. Concepts may exaggerate items for readability.

## Readability exaggeration

The following may be intentionally oversized relative to realism:

- coconuts and fruit;
- crab claws/body;
- stones intended to be picked up;
- tool heads and handles;
- crate structural members;
- rope bindings;
- campfire stones/flames;
- stool/seat thickness;
- shelter poles and roof panels;
- interaction handles, lids and openings.

The governing question is not “is this realistic?” but “does Wilson's intended action remain clear at the canonical camera distance?”

## Relative-size tiers

Use these tiers during concepting and asset reviews:

### Tiny hand prop

Approximately palm-sized to forearm-sized. Must still be visible when held.

Examples: stone, fruit, cup, small tool.

### Carry prop

Clearly visible in Wilson's hands and often requiring pose accommodation.

Examples: log bundle, crate, large container, bowling ball.

### Camp prop

Anchors an interaction location and reads from across the immediate camp.

Examples: stool, table, storage chest, campfire, workbench.

### Structure

Creates navigation/occlusion and should read as a persistent camp landmark.

Examples: shelter, raft, larger storage, project frame.

### Environmental landmark

Shapes navigation and scene composition.

Examples: palm, large boulder, cliff mass, tide pool.

## Density and spacing

A living diorama needs visual richness but also action clearance.

Prefer clustered density:

- richer vegetation around scene edges and natural boundaries;
- clearer traversable pockets around camp and interaction anchors;
- intentional negative space around important props;
- overlap in background clusters, not at the cost of Wilson/action readability.

Avoid distributing filler objects uniformly across the terrain.

## Canonical preview scene requirements

The eventual preview scene should contain:

- canonical orthographic camera;
- neutral daylight lighting;
- standard ground patch;
- Wilson mannequin/reference;
- 1 m measurement reference hidden from beauty renders;
- known reference assets: coconut, crate, stool, rock, palm segment;
- optional shadow/contact test plane.

Every asset family should be reviewed in this scene before acceptance.

## Screenshot readability test

For each important scene render:

1. inspect at native resolution;
2. reduce to approximately 50% linear size;
3. reduce again to a small thumbnail;
4. verify Wilson, action target and major state remain identifiable.

If readability collapses early, improve silhouette, spacing, scale or color grouping before adding detail.
