# Production Review / Export Workflow Moved

The production Blender review/export workflow is canonical under:

```text
tools/blender/README.md
```

and implemented by:

```text
tools/blender/review_asset.py
tools/blender/validate_asset.py
tools/blender/export_asset.py
```

This file remains only as a compatibility pointer for older prototyping references.

`docs/prototyping/blender/` owns smoke/integration-test modeling guidance. It does **not** own the production asset pipeline.

For production assets, use:

1. `docs/asset-catalog/` for modeled-content requirements;
2. `docs/ASSET_SPEC.md` / `docs/ASSET_PIPELINE.md` for technical contracts;
3. `docs/art/AGENT_ART_PRODUCTION.md` for artistic review requirements;
4. `tools/blender/README.md` for the operational scripts, AssetScope, source-ownership and profile rules.
