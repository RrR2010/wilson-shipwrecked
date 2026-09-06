from __future__ import annotations

import html
import json
import sys
from pathlib import Path


def _read_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def build_index(review_root: Path, repo_root: Path | None = None) -> dict:
    review_root = review_root.resolve()
    review_root.mkdir(parents=True, exist_ok=True)
    cards = []

    for asset_dir in sorted(path for path in review_root.iterdir() if path.is_dir()):
        latest_path = asset_dir / "latest.json"
        if not latest_path.is_file():
            continue
        latest = _read_json(latest_path)
        manifest_ref = latest.get("manifest", "")
        manifest_path = None

        if repo_root and manifest_ref:
            candidate = (repo_root / manifest_ref).resolve()
            if candidate.is_file():
                manifest_path = candidate
        if manifest_path is None:
            iteration = int(latest.get("latest_iteration", 0))
            candidates = list(
                (asset_dir / f"iter_{iteration:02d}").glob("*_review_manifest.json")
            )
            if candidates:
                manifest_path = candidates[0]

        manifest = (
            _read_json(manifest_path)
            if manifest_path and manifest_path.is_file()
            else {}
        )
        sheet_ref = latest.get("review_sheet") or manifest.get("review_sheet", "")
        if repo_root and sheet_ref:
            try:
                sheet_path = (repo_root / sheet_ref).resolve()
                sheet_rel = sheet_path.relative_to(review_root).as_posix()
            except Exception:
                sheet_rel = sheet_ref
        else:
            sheet_rel = sheet_ref

        cards.append(
            {
                "asset_id": latest.get("asset_id", asset_dir.name),
                "latest_iteration": latest.get("latest_iteration", 0),
                "review_profile": manifest.get("review_profile", ""),
                "scope": manifest.get("scope", {}),
                "review_sheet": sheet_rel,
            }
        )

    payload = {"assets": cards}
    (review_root / "index.json").write_text(
        json.dumps(payload, indent=2, sort_keys=True),
        encoding="utf-8",
    )

    card_html = []
    for card in cards:
        asset = html.escape(str(card["asset_id"]))
        profile = html.escape(str(card["review_profile"]))
        iteration = int(card["latest_iteration"])
        sheet = html.escape(str(card["review_sheet"]))
        image = (
            f'<img src="{sheet}" alt="{asset} review sheet">'
            if sheet
            else '<div class="missing">No review sheet</div>'
        )
        card_html.append(
            f"""
            <article class="card">
              <h2>{asset}</h2>
              <p>iteration {iteration:02d} · {profile}</p>
              {image}
            </article>
            """
        )

    document = f"""<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Wilson Shipwrecked — Blender Review Index</title>
<style>
body {{ font-family: sans-serif; margin: 24px; background: #1f2226; color: #eef1f4; }}
.grid {{ display: grid; grid-template-columns: repeat(auto-fit, minmax(420px, 1fr)); gap: 18px; }}
.card {{ background: #2a2e33; padding: 14px; border-radius: 8px; }}
.card h2 {{ margin: 0 0 4px; font-size: 18px; }}
.card p {{ margin: 0 0 12px; color: #b9c0c7; }}
.card img {{ width: 100%; height: auto; display: block; background: #17191c; }}
.missing {{ padding: 40px; background: #17191c; color: #8e959c; text-align: center; }}
</style>
</head>
<body>
<h1>Blender Review Index</h1>
<div class="grid">
{''.join(card_html)}
</div>
</body>
</html>
"""
    (review_root / "index.html").write_text(document, encoding="utf-8")
    return payload


if __name__ == "__main__":
    root = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("temp/blender-review")
    print(json.dumps(build_index(root), indent=2, sort_keys=True))
