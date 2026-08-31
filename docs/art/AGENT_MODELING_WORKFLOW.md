# Artistic 3D Agent Modeling Workflow

## Purpose

This document defines the **artistic reasoning and review loop** for autonomous or assisted 3D-modeling agents working on Wilson Shipwrecked.

It intentionally does not prescribe Blender integration, MCP commands, export scripts, file APIs, or engine implementation details. Those belong to the technical asset pipeline.

The goal here is to make an agent consistently answer:

> What should I build, what visual references should I use, how should I inspect it, and when is the model artistically ready?

---

# 1. Source hierarchy

Before modeling, read sources in this order.

## Tier 1 — mandatory visual contracts

1. `../VISUAL_GUIDE.md`
2. `ART_DIRECTION.md`
3. `SHAPE_LANGUAGE.md`
4. `PALETTE_AND_MATERIALS.md`
5. `SCALE_CAMERA_AND_READABILITY.md`

These define the non-negotiable project visual language.

## Tier 2 — relevant family references

Read only the reference documents relevant to the current asset family, for example:

- `reference/REFERENCE_02_NATURAL_ISLAND_VOCABULARY.md`
- `reference/REFERENCE_03_CAMP_PRIMITIVE_PROPS.md`
- `reference/REFERENCE_05_TOOL_GRAMMAR.md`
- `reference/REFERENCE_06_SHELTER_EVOLUTION.md`
- `reference/REFERENCE_07_SALVAGE_REPURPOSING.md`
- `reference/REFERENCE_08_WEATHER_DAMAGE.md`
- `reference/REFERENCE_09_WILSON_SCALE_INTERACTION.md`

When an approved visual sheet exists in `reference/visual/`, inspect it before modeling.

Visual sheets are references, not literal blueprints. Preserve the grammar, not accidental AI-image artifacts.

## Tier 3 — functional context

Use:

- `ASSET_FAMILIES.md`;
- relevant files in `../brainstorming/functional-asset-catalog/`;
- representative scenes where useful.

These explain what the object needs to support, but they do not override the visual contracts.

## Tier 4 — asset or family brief

A production asset should have a compact brief whenever its requirements are not already obvious from an existing approved family.

The brief is the immediate task contract.

---

# 2. Brief granularity

Do **not** create one long bespoke specification for every trivial object.

Use three levels.

## Level A — grammar-only asset

Examples:

- small rock variant;
- simple log;
- plank;
- rope coil;
- generic coconut;
- simple bowl.

If the family grammar fully defines the asset, the task may only need:

- asset ID;
- family;
- approximate dimensions;
- required state/variant;
- any required anchor.

## Level B — family brief

Use one shared brief for a reusable family such as:

- rock family;
- palm family;
- crate family;
- primitive seating;
- tool handles / tool heads;
- storage containers.

The family brief defines shared construction, variation boundaries, state vocabulary and review criteria.

Individual variants inherit from it.

## Level C — asset-specific brief

Create a dedicated brief when the object has one or more of:

- important modular composition;
- unique interaction anchors;
- visible project evolution;
- meaningful damage/repair states;
- unusual gameplay proportions;
- rare authored identity;
- non-obvious repurposing requirements;
- strong scene/story importance.

Examples:

- shelter project;
- raft;
- dock;
- mystery metal container;
- specific rare salvage object;
- Wilson.

---

# 3. Modeling reasoning loop

Each asset passes through the following artistic loop.

```text
READ
  ↓
INTERPRET
  ↓
BLOCK OUT
  ↓
APPLY FAMILY GRAMMAR
  ↓
APPLY MATERIAL BLOCKS
  ↓
RENDER CANONICAL VIEWS
  ↓
SELF-REVIEW
  ↓
REVISE
  ↓
INDEPENDENT REVIEW
  ↓
FINAL CORRECTION
  ↓
ARTISTIC ACCEPTANCE
```

---

# 4. Step 1 — Read and summarize the task

Before modeling, the agent should internally summarize:

- what family this asset belongs to;
- the object’s dominant silhouette;
- gameplay-relevant dimensions;
- required variants or states;
- required composition/modules;
- required anchors/sockets where artistically relevant;
- which visual sheet is authoritative for the family;
- what must *not* be added.

If the asset can be built from an existing grammar, prefer that over invention.

---

# 5. Step 2 — Identify the primary read

Every asset should have a clear **primary visual read**.

Examples:

- rock: broad irregular mass;
- crate: chunky manufactured box with readable slat/frame construction;
- palm: tapered segmented trunk + radial broad-frond crown;
- hammer: handle + heavy head + visible binding;
- shelter: readable frame + roof mass + visible bindings;
- raft: tied buoyant longitudinal members + broad usable deck silhouette.

If the agent cannot describe the asset in one short silhouette-oriented phrase, the design is probably too complicated.

---

# 6. Step 3 — Blockout before detail

Start with the fewest large forms required to establish:

- silhouette;
- proportions;
- contact with the ground;
- mass distribution;
- interaction scale;
- modular arrangement.

Do not start with:

- bevels;
- scratches;
- rope fibers;
- leaf veins;
- tiny hardware;
- decorative cuts;
- unique textures.

The blockout should already read from the gameplay camera.

---

# 7. Step 4 — Apply aggressive low-poly grammar

Refine using intentional planes rather than smooth surfaces or random faceting.

Ask:

- does each added edge improve silhouette, planar read, deformation, or state readability?
- can any geometry be removed without hurting the primary read?
- are curved objects visibly simplified without becoming voxel-like?
- are thin elements thick enough to survive gameplay distance?

The correct target is **simple and authored**, not merely low triangle count.

---

# 8. Step 5 — Apply material blocks

The default production asset uses:

- shared flat-color materials;
- low material-slot count;
- roughness/specular differences only where useful;
- no unique texture map.

Before adding any texture/decal/noise, ask:

> Is this information important enough to survive gameplay distance, and can geometry, color blocking or a shared state shader communicate it instead?

If yes, do not add the texture.

Decals and texture-like effects are exceptions for semantic markings or specific functionality.

---

# 9. Step 6 — Canonical preview set

Every reviewable asset should produce the standard views defined in `CANONICAL_ASSET_PREVIEWS.md`.

Minimum set:

1. front orthographic;
2. side orthographic;
3. top orthographic;
4. canonical gameplay orthographic 3/4;
5. silhouette check from gameplay camera;
6. scale comparison with Wilson mannequin when scale is not trivial.

For asymmetrical or modular assets, add a rear/alternate 3/4 view if it reveals important construction.

---

# 10. Step 7 — Self-review

The creating agent reviews the rendered images, not only the mesh structure.

It should explicitly inspect:

- silhouette;
- proportion;
- family consistency;
- faceting quality;
- unnecessary detail;
- material simplicity;
- scale/readability;
- ground contact;
- composition clarity;
- state differentiation;
- repair/history readability where applicable;
- resemblance to approved sheets without literal copying.

Use `VISUAL_REVIEW_RUBRIC.md`.

The agent must identify concrete weaknesses before declaring the asset ready.

---

# 11. Iteration limits

Iterate until the asset is good, but avoid unbounded polishing.

Recommended default:

- up to **4 creator review cycles**;
- each cycle should target the largest remaining artistic problem;
- do not spend a cycle on invisible micro-detail.

If the asset still fails a major criterion after four cycles, stop polishing blindly and report the unresolved design conflict.

The iteration limit is a guard against spending agent time optimizing details that do not improve gameplay readability.

---

# 12. Independent reviewer loop

After self-review passes, invoke a separate review context/subagent using the same capable visual model where practical.

The reviewer should receive:

- the asset brief;
- relevant visual/text references;
- canonical preview renders;
- no creator self-justification unless needed later.

This reduces confirmation bias.

The reviewer should **not remodel the asset**. It evaluates and returns:

1. pass / conditional pass / fail;
2. rubric scores;
3. at most three highest-value corrections;
4. any reference mismatch;
5. whether the asset appears overbuilt for its gameplay role.

The reviewer should prioritize problems visible in the canonical gameplay view over problems visible only in close-up.

---

# 13. Final correction loop

After independent review:

- `PASS` → accept;
- `CONDITIONAL PASS` → creator makes one focused correction pass;
- `FAIL` → creator may perform up to two focused passes and rerender.

If a second independent review still fails for the same structural reason, flag the asset for human/design review instead of endlessly iterating.

---

# 14. Artistic acceptance conditions

An asset is artistically ready when:

- its function is legible without explanatory text;
- it clearly belongs to its family;
- it matches the approved low-poly intensity;
- its silhouette works at gameplay distance;
- it uses the simplest sufficient material strategy;
- states are visually distinct where required;
- modular construction is understandable where relevant;
- it does not introduce a new aesthetic language unnecessarily;
- its canonical gameplay preview passes independent review.

A beautiful close-up that becomes unclear in the gameplay camera is not accepted.

---

# 15. Family consistency rule

When producing a second, third or later member of a family, inspect at least two already-approved family members if available.

The question changes from:

> Is this object attractive?

into:

> Does this object extend the family without breaking its visual grammar?

New variants should usually differ through:

- proportions;
- part selection;
- bounded asymmetry;
- state;
- palette variant;
- composition.

Do not use increased detail as the primary source of variation.

---

# 16. Project-object rule

Large projects require review at multiple construction stages, not only when completed.

For shelter, raft, dock, workstation expansions and similar objects, preview at minimum:

- early stage;
- recognizable partial stage;
- complete stage;
- one damage or repair state when relevant.

Intermediate states must look intentional rather than like missing meshes.

---

# 17. Review philosophy

The agent is not trying to prove that its first attempt is correct.

The loop exists to expose discrepancies between:

- textual intent;
- reference sheet;
- actual geometry;
- canonical gameplay read.

Prefer a simple model that survives all four comparisons over a sophisticated model that only looks good in isolation.
