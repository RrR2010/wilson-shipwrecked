# Visual Production Support Pack

This directory turns the project visual direction into operational guidance for humans and autonomous 3D agents.

It supplements, but does not replace:

- `../VISUAL_GUIDE.md` — visual source of truth;
- `../ASSET_SPEC.md` — runtime asset contract;
- `../ASSET_PIPELINE.md` — technical asset workflow.

## Locked baseline

> A colorful tropical miniature diorama with an orthographic 3/4 gameplay camera, intentionally aggressive low-poly environment geometry, broad readable silhouettes, restrained surface detail, and a softer caricatured Wilson who remains visually distinct from the more faceted world.

Common assets default to shared flat-color materials with no unique texture maps. Complexity should come from form, composition, state, lighting and persistent history rather than surface detail.

## Document authority map

### 1. Core visual direction

Read for project-wide visual decisions:

- [`ART_DIRECTION.md`](ART_DIRECTION.md) — target, mood, complexity hierarchy and persistent-state philosophy.
- [`SHAPE_LANGUAGE.md`](SHAPE_LANGUAGE.md) — geometry, silhouette and faceting grammar.
- [`PALETTE_AND_MATERIALS.md`](PALETTE_AND_MATERIALS.md) — flat-material, palette and texture policy.
- [`SCALE_CAMERA_AND_READABILITY.md`](SCALE_CAMERA_AND_READABILITY.md) — scale, camera and gameplay-readability rules.

These are technical appendices to `../VISUAL_GUIDE.md`, not competing sources of truth.

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

### 3. Production backlog

Use [`production/`](production/) to decide what to model next and to track status.

The production catalogs replace the older `ASSET_FAMILIES.md` taxonomy and are the only mutable art-production backlog.

### 4. Agent execution contract

- [`AGENT_ART_PRODUCTION.md`](AGENT_ART_PRODUCTION.md) — modeling loop, canonical previews, self-review, independent review and acceptance.
- [`ASSET_BRIEF_TEMPLATE.md`](ASSET_BRIEF_TEMPLATE.md) — compact grammar/family/asset-specific task contract.

Do not split preview/review rules into separate agent prompts; `AGENT_ART_PRODUCTION.md` is the single operational source.

## Agent minimum reading path

For normal production work:

```text
VISUAL_GUIDE.md
→ relevant core art docs
→ relevant REFERENCE_*.md + approved visual sheet
→ matching production catalog row
→ family/asset brief when required
→ AGENT_ART_PRODUCTION.md
```

Do not use Rounds 1–10 as the default modeling prompt. They remain upstream historical/design evidence in `../brainstorming/functional-asset-catalog/`.

## Brief strategy

- **grammar-only task** for trivial variants fully covered by a reference grammar;
- **family brief** for reusable families with shared construction/variation rules;
- **asset-specific brief** only for modular, stateful, rare or high-risk assets.

Avoid one bespoke document per simple prop.

## Production principle

Aim for **maximum systemic variety inside a narrow visual grammar**.

The gameplay camera is authoritative. A close-up render cannot rescue an asset that is unreadable in normal play.

## Remaining art-block work

The direction layer is substantially closed. Remaining work is calibration and production:

1. keep the approved reference PNG set complete;
2. calibrate exact palette/material values in a real preview scene;
3. calibrate final gameplay camera values;
4. create briefs just-in-time for production batches;
5. validate the agent loop on a representative pilot batch;
6. build the golden scene from approved production assets.
