# Asset Catalog — Representative Scene Coverage

## Purpose

This document regression-checks the normalized cross-cutting asset catalog against the 40 historical representative scenes in `docs/brainstorming/representative-scene-catalog.md`.

The scene catalog is **behavioral/content evidence**, not a script catalog. A scene passes when the stabilized domain plus catalogued content can produce an equivalent player-visible chain through ordinary actions, world mutation, perception/evidence, cognition, projects, Director opportunities and presentation adapters.

This matrix uses two results:

```text
PASS
  the domain is sufficient and the required content/presentation family is catalogued;
  production status may still be TODO/DEFERRED

RESHAPE
  the historical literal scene conflicts with a later canonical decision;
  the intended phenomenon remains supported through its canonical reshape
```

---

# 1. Coverage matrix

| # | Scene | Result | Main catalog/domain support | Note |
|---:|---|---|---|---|
| 1 | The Good Chair | PASS | `flat_rock`, `stool_crude`, `log_short`; sit affordance; persistent `EntityId`; association + habit | Preference remains Wilson cognition. |
| 2 | Breakfast First | PASS | food storage projects/containers, `fruit_generic`; habit + drive/intention competition | No special routine state. |
| 3 | The Long Way Around | PASS | `place.tide_pool`, crab, route queries, place association/history | Avoidance is Wilson-relative, not a place hazard flag. |
| 4 | Scientific Method | PASS | `sealed_metal_container`, interaction regions, branch/stone/tool candidates, diagnostic feedback/evidence | Strong physical-discovery regression. |
| 5 | The Perfectly Good Bowling Ball | PASS | `bowling_ball_rare`, generic impact semantics, effective mass/hardness, dynamic rolling | No coconut-specific interaction. |
| 6 | Absolutely Not | PASS | unfamiliar local entity + suggestion source + intention competition | Refusal remains ordinary autonomy. |
| 7 | Fine! | PASS | `hatlike_salvage`; suggestion/autonomy; qualified `carried_by` body-slot mode + presentation adapter | No equipment system or `worn_by` relation. |
| 8 | The Missing Spoon | PASS | `spoon_utensil`, stable placement relations, expectation mismatch, player relocation | Expected location is belief/habit semantics. |
| 9 | The Benefactor | PASS | project material roles, interventions, presence trust/dependency/expectation | No gifted-resource state. |
| 10 | The Traitorous Fire | PASS | `project.fire_site`, persistent site identity, fire process, association/history | Fire lifecycle remains environment/world truth. |
| 11 | Gerald | PASS | `animal.crab_recurring`, persistent `EntityId`, shallow actor steal/carry activity | Rivalry is Wilson cognition. |
| 12 | Victory Lap | PASS | recurring crab, food, `terrain.shallow_hole`, movement/body consequence | Comedy and injury compose normally. |
| 13 | One More Piece | PASS | `project.shelter_basic`, interchangeable components, hunger drive, project continuation | Partial construction remains world truth. |
| 14 | Roof or Table? | PASS | shelter + `project.work_surface_basic`, shared component roles, competing intentions | No resource reservation or optimal-choice rule. |
| 15 | Interior Design | PASS | `shell_decorative`, ordinary placement/history, `project.decorative_arrangement` | Aesthetic meaning is not an entity capability. |
| 16 | The Laundry Problem | PASS | `garment_cloth_basic`, `project.clothesline`, moisture/drying, rain/wind | No laundry state machine. |
| 17 | Storm Priorities | PASS | loose props, wind displacement, shelter/storage/protection, decorative content | Priority conflict is Wilson cognition. |
| 18 | The Umbrella | PASS | `umbrella_found`, deployable configuration, covering/protection, wind load | Failure is grounded configuration/component change. |
| 19 | Midnight Noise | PASS | ordinary loose/attached object, auditory evidence, night perception, investigation | No noisy-object family required. |
| 20 | The Mushroom | PASS | `mushroom_generic`, hidden edibility/toxicity truth, uncertain evidence, hunger/risk competition | No omniscient safety reveal. |
| 21 | Faster Than Walking | PASS | `sign_panel`/flat salvage, sandy slope, sliding `DynamicProcessState`, injury | Improvised sled is a use/configuration, not a vehicle recipe. |
| 22 | Too Hot | PASS | fire/cooking content, reach tools, prior injury -> association/belief | Excess caution remains cognition. |
| 23 | The Bottle | PASS | `bottle_jar`, transparent/opaque evidence, closure/contents, unresolved intention | Strong exploration/evidence regression. |
| 24 | Rotten Luck | PASS | fruit freshness/spoilage, storage contents, hunger/project interruption | Spoilage is world evolution. |
| 25 | Inspection Day | PASS | fire process, fuel, habit and recurring check intention | No inspection-required flag. |
| 26 | Someone Moved the Rock | PASS | `flat_rock`, placement expectation, player relocation, causal attribution | Preferred spot remains habit/association. |
| 27 | The Gift Test | PASS | fruit + support surface + deliberate arrangement + presence investigation | Offering meaning is Wilson intention/proposition. |
| 28 | Miracle Fatigue | PASS | generic heavy object, intervention history, presence dependency/expectation | No help-request state. |
| 29 | Sabotaged Storage | PASS | containers, contents relations, project roles, epistemic investigation | Canonical broad integration fixture. |
| 30 | The Unwanted Rescue | RESHAPE | intervention causal windows, action commitment, ordinary relocation | Target/support/route must change while the causal window is still open; no retroactive physical incoherence. |
| 31 | The Signal Fire | PASS | `project.fire_site`, fuel/smoke process, `directed.distant_human_contact`, Director opportunity | Boat/aircraft are distant event/presentation content, not necessarily local simulated vehicles. |
| 32 | Not Now, Humanity | RESHAPE | `directed.distant_human_contact`, Director opportunity + normal autonomy/interruption | Toilet-like urgency remains excluded; use an admitted competing pressure/history. |
| 33 | The Neighbor | PASS | `place.neighbor_islet`, route/topology conditions, ordinary carrying/association/history | Content is catalogued as P2/deferred production; functional coverage is complete. |
| 34 | Captain Wilson | PASS | `shipwreck_structural_section`, wreck access regions, `buoy_life_ring`, ordinary salvage | Helm/cabin may be regions/presentation on the wreck. |
| 35 | The Statue of Gerald | PASS | `shell_decorative`, stones, `project.decorative_arrangement`, Gerald history | No bespoke Gerald-statue primitive. |
| 36 | Gerald Is Missing | PASS | recurring crab identity, expected place/activity, absence evidence, association | Absence is expectation mismatch, not `animal_missing`. |
| 37 | The Falling Palm | PASS | palm, storm weakening, `DynamicProcessState`, perceived threat, intervention window, body effects | Canonical hazard fixture. |
| 38 | The Brilliant Shortcut | PASS | `log_long`, wet/slippery traversal context, cargo, route alternatives, death lifecycle | Grounded autonomous death remains reconstructable. |
| 39 | I Hate Mushrooms | PASS | mushroom category + resurrection persistence + association/belief asymmetry | Aversion survives in cognition, not entity metadata. |
| 40 | The Experiment | PASS | ordinary movable objects, deliberate arrangement, expectation comparison, presence attribution | No explicit player identity/fourth-wall entity required. |

---

# 2. Scene-exposed content now owned by the catalog

The earlier regression exposed five content requirements. They are now represented in their normal catalog owners rather than maintained as a second backlog here.

| Requirement | Canonical catalog owner | Priority / status | Domain treatment |
|---|---|---|---|
| Hat-like/wearable salvage | `ENTITIES.md` → `hatlike_salvage` | P1 / `Spec=ALIGNED` | ordinary `carried_by` with bounded body-slot qualifier + presentation adapter; no equipment aggregate |
| Decorative shell/curio | `ENTITIES.md` → `shell_decorative` | P1 / `Spec=ALIGNED` | ordinary small persistent entity; personal/aesthetic value remains cognition/history |
| Persistent decorative/sculptural arrangement | `PROJECTS.md` → `project.decorative_arrangement` | P1 / `Spec=ALIGNED` | generic project reads grounded positions/relations; no duplicate layout state or bespoke Gerald-statue project |
| Distant human-contact opportunity | `LIVING_WORLD.md` → `directed.distant_human_contact` | P0 / `Spec=ALIGNED` | `DirectedEventDefinition` + presentation binding; no local fake vehicle or rescue meter required |
| Neighboring islet / temporary access | `LIVING_WORLD.md` → `place.neighbor_islet` | P2 / `Spec=ALIGNED`, production deferred | ordinary place/region/topology/environment semantics; no scene portal |

`SCENE_COVERAGE.md` therefore owns **regression evidence only**. Production work is tracked by the `Status`/priority columns in the catalog owner files.

---

# 3. Historical scenes intentionally reshaped

## Scene 30 — The Unwanted Rescue

The original version moves a target after Wilson has physically committed his reach around that target. Later causal-window rules correctly reject retroactive physical incoherence.

Supported equivalent:

```text
Wilson prepares a risky action
→ player changes target/support/route while causally open
→ preparation becomes useless or less safe
→ Wilson perceives the result
→ anger/trust/attribution derive from Wilson's outcome, not player intent
```

## Scene 32 — Not Now, Humanity

The original invents toilet-like urgency solely to interrupt a directed event. Later behavioral validation intentionally rejected that drive expansion.

Supported equivalent:

```text
rare human-contact opportunity
+ admitted ordinary pressure/history
→ Wilson may still miss or break the directed scene
```

Examples include Gerald threatening exposed food, an admitted body/drive pressure, a storm/project consequence or another high-salience anomaly. The Director biases opportunity; it does not suspend ordinary autonomy.

---

# 4. Game-loop coverage by phenomenon family

| Phenomenon | Representative scenes | Loop shape | Result |
|---|---|---|---|
| Quiet routine / preference | 1, 2, 25, 36 | perception → habit/association/expectation → intention competition → action → persistent world/history | PASS |
| Physical experimentation / discovery | 4, 5, 20, 21, 23 | evidence → speculative tactic → attemptability → committed action → physical outcome/diagnostics → new evidence/learning | PASS |
| Project continuation / competition | 13, 14, 15, 35 | project opportunity → contribution intention → world action/mutation → project reads grounded outcome → continue/pause/complete | PASS |
| Player intervention / unseen presence | 8, 9, 26–30, 40 | validated intervention → world mutation → perception → expectation mismatch → attribution/belief/association → later behavior | PASS; Scene 30 uses causal-window reshape |
| Persistent shallow actors | 3, 11, 12, 36 | actor activity + persistent identity → perception → Wilson history/association → future expectation | PASS |
| Environment / domestic change | 16–19, 24 | environment/time → response/process → property/relation/spatial mutation → evidence → Wilson adaptation | PASS |
| Hazards / death | 37–39 | dynamic process → warning evidence → threat decision/intervention window → collision/body consequence/death → persistent cognition | PASS |
| Directed opportunities | 31, 32 | Director opportunity → perception/salience → ordinary intention competition → ordinary physical actions → event resolves/expires | PASS; Scene 32 uses behavioral reshape |
| Additional location | 33, 34 | route/access opportunity → exploration/carry constraints → ordinary world history → return/persistence | PASS; neighboring-islet production remains P2 |

---

# 5. Regression conclusion

**Representative-scene catalog coverage: PASS for the accepted phenomenon suite.**

All scene-exposed reusable content requirements now have explicit catalog rows. The two `RESHAPE` cases are intentional consequences of later canonical decisions rather than missing system capability.

The regression found no need for a new broad state-owning system, recipe layer, equipment aggregate, scene-script authority, special Gerald system, decorative state owner or rescue progression model.

Future scene proposals should follow the same rule:

1. first try composition from existing domain semantics and catalog families;
2. if reusable content is missing, add it to the appropriate catalog owner;
3. only reopen canonical domain vocabulary when a genuinely reusable semantic gap cannot be represented without distortion.