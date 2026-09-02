# Design Reviews

This directory stores temporary design/calibration reviews produced while evaluating implementation proposals against product intent, representative scenes and existing canonical contracts.

These files are **advisory evidence**, not canonical specifications.

Each review should include:

- an explicit `Status: OPEN` or `Status: COMPLETED` marker;
- the implementation/PR or decision being reviewed;
- the evidence used for calibration;
- actionable findings or a checklist;
- a completion record identifying the consuming PR/commit;
- rationale for recommendations that were deliberately rejected or deferred.

When implementation work consumes a review, follow the root `AGENTS.md` workflow. Do not mark a review complete until all applicable items are resolved or explicitly dispositioned.

Durable decisions discovered through a review belong in the appropriate canonical document. Completed reviews remain historical calibration evidence and should not become a parallel contract layer.
