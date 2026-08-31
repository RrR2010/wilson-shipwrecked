# Art Direction

## Target statement

Wilson Shipwrecked should look like a **playable tropical tabletop diorama** built from deliberately simplified 3D forms.

The target is not generic low-poly. The visual identity comes from the combination of:

- aggressive polygon simplification in the environment;
- large coherent color masses;
- orthographic 3/4 framing;
- warm tropical readability;
- modular handmade structures;
- strong persistent visual state;
- a softer, more human Wilson silhouette that remains clearly readable against the faceted world.

## Chosen style axis

### Environment

Use visibly faceted geometry. Large planes are desirable when they improve readability and reduce modeling complexity.

Preferred characteristics:

- rocks with 6–20 dominant visible planes instead of smooth sculpted surfaces;
- palm trunks built from a small number of tapered segments;
- leaves represented by broad planar or lightly folded blades/clusters;
- terrain shaped in broad low-frequency masses;
- sand, cliffs and water readable through geometry/color blocks rather than texture detail;
- props made from visibly simple parts;
- handmade structures composed from reusable logs, planks, rope bindings and leaf/thatch panels.

### Wilson

Wilson must **not** inherit the harshest faceting or a gothic/exaggerated horror-comedy look.

Preferred character direction:

- recognizable adult human proportions, caricatured for gameplay readability;
- moderately enlarged head and hands;
- simplified but softer face planes than the environment;
- expressive brows, eyes, hands and body pose;
- medium-short limbs, not tiny stick limbs;
- readable hair mass, but avoid extreme vertical spikes or highly graphic silhouette gimmicks;
- no permanent gaunt/depressed expression;
- no visual dependency on outlines.

The contrast is intentional: **the world can look more carved/faceted than Wilson**.

## Mood

Primary mood:

- inviting;
- curious;
- warm;
- lightly comedic;
- handmade;
- persistent and lived-in.

Secondary moods such as storms, night, danger or loneliness may change lighting and saturation, but should not transform the project into horror or bleak survival realism.

## Complexity hierarchy

Visual complexity should follow gameplay importance:

1. Wilson and current interaction target;
2. active project / event focal point;
3. camp structures and important persistent objects;
4. navigational landmarks;
5. vegetation clusters and terrain;
6. background filler.

Do not spend geometry or material complexity uniformly.

## Detail philosophy

Prefer a detail only when it contributes to one of:

- silhouette;
- semantic state;
- material identification;
- interaction readability;
- persistent history;
- humor;
- scale recognition.

Avoid detail whose only purpose is to make an asset look more realistic in a close-up turntable.

## Persistent-state visual language

World history should remain visible whenever practical.

Examples:

- chopped palm -> missing crown / stump;
- damaged shelter -> missing or displaced panel;
- repaired shelter -> mismatched replacement piece;
- frequently used path -> reduced vegetation / altered ground material;
- storage -> visible accumulation or fullness state;
- wet object -> darker material variant;
- burned object -> simplified charred state;
- project -> progressively assembled components.

State changes should first modify silhouette or large color blocks; tiny decals are a last resort.

## Rendering target

The runtime look should be achievable with modest real-time rendering suitable for web distribution.

Favor:

- simple reusable materials;
- soft directional lighting;
- ambient fill;
- grounded contact shadows;
- restrained specular response;
- minimal or no texture dependence for common props;
- color variation through material parameters rather than unique texture sets.

Avoid making the target depend on expensive post-processing, complex subsurface shading, dense foliage transparency or high-resolution normal maps.

## Acceptance test

A screenshot should still read correctly when reduced substantially in size. At gameplay distance, a reviewer should be able to identify:

- Wilson;
- current action;
- major interactable props;
- important environmental states;
- major navigable areas;
- time/weather mood.

If the screenshot only becomes attractive when zoomed in, the asset language is too detailed for the project.
