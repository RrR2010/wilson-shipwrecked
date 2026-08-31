# Visual Production Support Pack

This directory turns the project visual direction into operational guidance for humans and autonomous 3D agents.

It supplements, but does not replace:

- `../VISUAL_GUIDE.md` — visual source of truth;
- `../ASSET_SPEC.md` — runtime asset contract;
- `../ASSET_PIPELINE.md` — technical asset workflow;
- `../asset-catalog/` — cross-cutting source of truth for what modeled assets exist and what they must support.

## Locked baseline

> A colorful tropical miniature diorama with an orthographic 3/4 gameplay camera, intentionally aggressive low-poly environment geometry, broad readable silhouettes, restrained surface detail, and a softer caricatured Wilson who remains visually distinct from the more faceted world.

Common assets default to shared flat-color materials with no unique texture maps. Complexity should come from form, composition, state, lighting and persistent history rather than surface detail.

## Document authority map

### 1. Core visual direction

- [`ART_DIRECTION.md`](ART_DIRECTION.md) — target, mood, complexity hierarchy and persistent-state philosophy.
- [`SHAPE_LANGUAGE.md`](SHAPE_LANGUAGE.md) — geometry, silhouette and faceting grammar.
- [`PALETTE_AND_MATERIALS.md`](PALETTE_AND_MATERIALS.md) — flat-material, palette and texture policy.
- [`SCALE_CAMERA_AND_READABILITY.md`](SCALE_CAMERA_AND_READABILITY.md) — scale, camera and gameplay-readability rules.

These are visual appendices to `../VISUAL_GUIDE.md`, not competing asset catalogs or domain sources.

### 2. Family reference pack

Text specs live in [`reference/`](reference/) and approved visual sheets in `reference/visual/`.

Current sequence:

1. Shape Grammar
2. Natural Island Vocabulary
3. Camp Primitive Props
4. Materials, Lighting & Performance
5. Tool Grammar
6. Shelter Evolution
7. Salvage & Repurposing
8. Weather & Damage
9. Wilson Scale & Interaction
10. Storage & Containers
11. Workstations & Utilities
12. Transport, Raft & Dock

Use only the references relevant to the current task. Visual sheets communicate shape intent; textual specs remain authoritative when an AI-generated sheet contains accidental artifacts or ambiguous details.

### 3. Asset selection and requirements

Use [`../asset-catalog/`](../asset-catalog/) to decide what model/family is required and to read its cross-cutting functional + artistic requirements.

`docs/art/` must not maintain a second object list.

### 4. Agent artistic execution

- [`AGENT_ART_PRODUCTION.md`](AGENT_ART_PRODUCTION.md) — artistic modeling loop, canonical previews, self-review, independent review and acceptance.
- [`ASSET_BRIEF_TEMPLATE.md`](ASSET_BRIEF_TEMPLATE.md) — optional compact family/asset-specific art brief when the catalog row + references are not sufficient.

`AGENT_ART_PRODUCTION.md` is the single operational source for artistic preview/review behavior.

## Agent minimum art reading path

For normal modeling work:

```text
asset-catalog row
→ VISUAL_GUIDE.md
→ relevant core art docs
→ relevant REFERENCE_*.md + approved visual sheet
→ optional family/asset brief
→ AGENT_ART_PRODUCTION.md
```

Do not use Rounds 1–10 as the default modeling prompt. They remain upstream historical/design evidence in `../brainstorming/functional-asset-catalog/`.

## Brief strategy

- **grammar-only task** when catalog + approved reference fully define a trivial variant;
- **family brief** when a family needs additional visual variation/construction constraints;
- **asset-specific brief** only for visually high-risk or unusually authored assets.

Functional requirements belong in the cross-cutting asset catalog or canonical domain docs, not in an art-only brief.

## Production principle

Aim for **maximum systemic variety inside a narrow visual grammar**.

The gameplay camera is authoritative. A close-up render cannot rescue an asset that is unreadable in normal play.

## Remaining art-block work

The direction layer is substantially closed. Remaining work is calibration and production:

1. keep the approved reference PNG set complete;
2. calibrate exact palette/material values in a real preview scene;
3. calibrate final gameplay camera values;
4. create art briefs only when catalog + references are insufficient;
5. validate the agent loop on a representative pilot batch;
6. build the golden scene from approved production assets.
