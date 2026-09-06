# Scale, Camera and Readability

## Coordinate baseline

Production assets share one local coordinate convention:

```text
1 Blender unit = 1 meter
+Y = canonical forward/front
+X = canonical right
+Z = up
```

Do not choose a different forward axis per family.

A runtime instance may be rotated freely in the world. The convention above defines the authored local frame so cars, boats, characters, furniture, structures and tools do not disagree about what `forward` means.

Assets without a meaningful semantic front still use a stable family orientation. Symmetry is not permission to switch axes arbitrarily between variants.

## Physical authored pose

Canonical review should show the asset in a physically meaningful normal rest or installed state.

Examples:

- loose branch/log → lying naturally;
- rock → resting on a plausible support face;
- crate/table/stool → on intended base/feet;
- rooted palm → upright;
- fallen vegetation → gravity-consistent fallen pose;
- installed wall/roof/panel → installed pose;
- floating/hanging asset → review without inventing a false ground-rest pose.

Do not stand a loose object upright merely to make framing easier.

## Canonical gameplay camera

Use an orthographic 3/4 camera as the primary review camera.

Until final game-scene calibration locks exact numbers, target approximately:

```text
azimuth:   ~45° around global +Z
 elevation: 32–38° downward
projection: orthographic
```

The camera is a stable world/view convention, not an asset-specific "best angle". Do not rotate every asset to present its prettiest side.

Top surfaces matter, silhouette overlap matters, and interaction props need readable footprints from above.

## Relative scale

Exact per-asset dimensions should not be hardcoded into an art-only table unless gameplay requires a specific measurement.

Judge scale in this order:

1. catalog/domain functional requirement when one exists;
2. Wilson mannequin/adult reference;
3. intended interaction;
4. approved siblings in the same family;
5. familiar neighboring assets.

Use an adult mannequin near **1.65–1.80 m** until Wilson's production height is locked.

Do not infer scale from concept images alone. Concept sheets may exaggerate objects for readability.

## Relative-size tiers

Use these as visual heuristics, not rigid dimensions.

### Tiny / hand prop

Palm-sized to forearm-scale and still visible when held.

Examples: fruit, cup, stone, small tool.

### Carry prop

Clearly visible in Wilson's hands/body pose.

Examples: crate, large container, bowling ball, log bundle.

### Camp prop

Anchors an interaction location.

Examples: stool, table, campfire, storage chest, workbench.

### Structure

Creates navigation/occlusion and reads as a persistent landmark.

Examples: shelter, raft, dock, project frame.

### Environmental landmark

Shapes navigation/composition at island scale.

Examples: palm, large boulder, cliff mass, tide pool.

## Readability exaggeration

Controlled oversizing is acceptable when required for gameplay read, especially for:

- fruit/coconuts;
- crab claws/body;
- pickup stones;
- tool heads/handles;
- rope bindings;
- lids/openings/handles;
- campfire stones/flames;
- shelter poles/panels.

The question is not only "is this realistic?" but:

> Does the object remain physically believable while making Wilson's intended interaction readable?

## Scale review

Use the canonical `scale` render whenever size is not trivial.

When possible, also compare with approved siblings or known reference props. Avoid gradual family-size drift across batches.

## Density and spacing

Prefer clustered density with usable negative space:

- richer vegetation near natural boundaries;
- clearer pockets around camp/interactions;
- intentional clearance around important props;
- background overlap without hiding Wilson or action targets.

Avoid uniform filler distribution.

## Readability test

For important renders:

1. inspect at native resolution;
2. inspect around half linear size;
3. inspect at small thumbnail scale;
4. verify asset identity and important state still read.

If readability collapses, improve silhouette, spacing, scale or color grouping before adding detail.
