# Functional Domain Regression — Representative Scenes

## Purpose

This document validates `DOMAIN_MODEL.md` against the complete 40-scene representative catalog in `brainstorming/representative-scene-catalog.md`.

The catalog is a **domain expressivity test suite**, not a mandate to implement the scenes as scripts.

For each scene the question is:

> Can the scene's setup, visible causal chain, variation and persistent consequence be represented by reusable domain concepts without adding scene-specific authoritative state or bypassing ownership boundaries?

Result classes:

- **PASS** — current functional domain can represent the essential phenomenon compositionally;
- **PASS + CONTENT** — domain is sufficient; authored definitions/rules/events/presentation are required but no new domain primitive;
- **PASS + REFINEMENT** — a domain capability needed to be made explicit; `DOMAIN_MODEL.md` has been refined accordingly;
- **RESHAPED PASS** — original catalog premise intentionally changed by canonical behavioral validation, while preserving the tested phenomenon;
- **FAIL** — domain lacks a justified reusable primitive.

Current result after the functional-domain pass: **no FAIL**.

---

# 1. Domain capability legend

| Code | Domain capability |
|---|---|
| `ENT` | entity definition/instance, properties, capabilities |
| `PLC` | stable place/region subject |
| `RELW` | authoritative world relations/arrangements |
| `ENV` | environment/weather/world processes |
| `BODY` | authoritative Wilson body/condition state |
| `ACTR` | lightweight non-Wilson actor runtime state |
| `AFF` | affordance + generic interaction rules |
| `OUT` | action outcome / partial diagnostic feedback / effects |
| `TRN` | transformations |
| `BLF` | Wilson beliefs/knowledge/expectations |
| `ASC` | association valence + attachment |
| `HAB` | habit cue → intention bias |
| `EPS` | selected episodic history |
| `DRV` | hunger/energy/comfort/stimulation pressure |
| `TRT` | curiosity/risk tolerance/independence |
| `INT` | current/suspended intention + competition |
| `REACT` | transient reaction/emotion |
| `PRJ` | project definition/instance/opportunities |
| `CAU` | causal attribution from observations/history |
| `PRS` | presence belief/trust/dependency |
| `PLY` | suggestion/intervention + God Power |
| `DIR` | Event/Scene Director opportunity/bias |
| `RUN` | death/resurrection/end-run lifecycle |

---

# 2. Full 40-scene regression matrix

| # | Scene | Essential domain path | Result | Notes / anti-hack check |
|---:|---|---|---|---|
| 1 | The Good Chair | `ENT + PLC + ASC + HAB + DRV + INT` | **PASS** | Rock preference is instance/place association + repeated habit. No `favorite_seat` primitive. |
| 2 | Breakfast First | `RELW + HAB + DRV + AFF + INT` | **PASS** | Morning storage check competes with nearby fruit. Routine remains emergent from habit, not a routine object. |
| 3 | The Long Way Around | `PLC + BLF + ASC + EPS + TRT + INT + REACT` | **PASS + REFINEMENT** | Stable place subjects were made explicit so danger can attach to the tide pool/route rather than arbitrary coordinates. |
| 4 | Scientific Method | `AFF + OUT + BLF + EPS + TRT + INT` | **PASS + REFINEMENT** | `ActionOutcome.diagnostic_feedback` explicitly supports dent/break/partial progress and immediate strategy refinement. |
| 5 | The Perfectly Good Bowling Ball | `ENT + AFF + OUT + TRN + BLF + ASC + BODY` | **PASS** | Same property/capability rule accepts bowling ball or conventional tool. Weight/exertion can affect desirability without pair recipes. |
| 6 | Absolutely Not | `PLY + TRT + DRV + BLF + INT + REACT + PRS` | **PASS** | Suggestion is a candidate influence. Sleep can still win. No suggestion-to-command conversion. |
| 7 | Fine! | `PLY + TRT + INT + REACT + ASC + EPS` | **PASS** | Suggestion window/count supports bounded insistence; irritation/refusal remains derived. Third suggestion never guarantees compliance. |
| 8 | The Missing Spoon | `RELW + BLF + HAB + EPS + CAU + PRS + PLY` | **PASS + REFINEMENT** | Expected arrangements are ordinary relation propositions. No special `moved_by_player` memory stat required. |
| 9 | The Benefactor | `PRJ + BLF + EPS + TRT + INT + PRS + PLY` | **PASS** | Dependency changes only when Wilson behaviorally relies/waits; missing material is a project/world fact. |
| 10 | The Traitorous Fire | `ENT + ASC + BLF + EPS + INT + PRJ + REACT` | **PASS** | Grudge attaches to fire-pit `EntityId`; present physical utility remains independently queryable. |
| 11 | Gerald | `ACTR + ENT + ASC + BLF + EPS + HAB + INT + REACT` | **PASS + REFINEMENT** | Gerald keeps persistent `EntityId`; animal only needs lightweight behavior. Wilson owns the rich relationship. |
| 12 | Victory Lap | `ACTR + ASC + REACT + INT + BODY + OUT + EPS` | **PASS** | Celebration temporarily modulates behavior; fall/injury is grounded body/world outcome. No scripted punchline requirement. |
| 13 | One More Piece | `PRJ + DRV + INT + OUT + PLY` | **PASS** | Stage completion proximity/continuity competes with hunger. Physical partial project remains world state. |
| 14 | Roof or Table? | `PRJ + BLF + ASC + TRT + INT + PLY + ENV` | **PASS** | Two legitimate project opportunities compete; weather expectation changes value without hardcoded rational planner. |
| 15 | Interior Design | `ENT + RELW + ASC + DRV + PRJ + INT + ENV` | **PASS** | Arrangement is world relations; aesthetic preferences can be associations to colors/material/categories/concepts. No decoration subsystem required. |
| 16 | The Laundry Problem | `ENT + RELW + ENV + BODY + BLF + HAB + INT` | **PASS + REFINEMENT** | Drying/wetting became explicit reusable environmental processes; wetness exists on items/body as authoritative state. |
| 17 | Storm Priorities | `ENV + ENT + RELW + ASC + BLF + INT + OUT + PLY` | **PASS** | Wind creates time-sensitive opportunities; attachment can outweigh stored-food priority temporarily. |
| 18 | The Umbrella | `ENT + AFF + OUT + TRN + ENV + BLF + ASC` | **PASS + CONTENT** | Open/use/invert/break behavior requires umbrella content definitions, but generic action/result/transform model is sufficient. |
| 19 | Midnight Noise | `ENV + RELW + BLF + INT + REACT + EPS + PLY` | **PASS + CONTENT** | Perception contracts need sound channel/context already covered by semantic observation contracts; loose object cause remains world truth. |
| 20 | The Mushroom | `ENT + AFF + BLF + DRV + TRT + INT + BODY + PLY + REACT` | **PASS** | Wilson uncertainty differs from world edibility/toxicity. Suggestion cannot bypass risk competition or physical consequence. |
| 21 | Faster Than Walking | `ENT + PLC + AFF + OUT + TRT + BLF + HAB + BODY + INT` | **PASS** | Sled shortcut emerges from slide-compatible properties/context; successful repetition can become habit/route expectation. |
| 22 | Too Hot | `BODY + EPS + BLF + ASC + AFF + INT + REACT` | **PASS** | Prior burn creates danger belief/association. Longer-stick workaround is normal affordance search under perceived risk. |
| 23 | The Bottle | `ENT + AFF + BLF + INT + EPS + ASC + PLY` | **PASS** | Suspended intention preserves unresolved interest without turning bottle into a project. |
| 24 | Rotten Luck | `ENV + RELW + DRV + BLF + HAB + INT` | **PASS + REFINEMENT** | Food spoilage is an environmental process; changed stored-food state redirects ordinary intention competition. Scene name does not require Luck mechanic. |
| 25 | Inspection Day | `ENV + BLF + EPS + HAB + INT` | **PASS** | Fire failures reinforce preventive cue/action habit. Successful ordinary night need not create an episode every time. |
| 26 | Someone Moved the Rock | `ENT + PLC + RELW + HAB + ASC + BLF + CAU + PRS + PLY` | **PASS** | Same expected-relation model as Missing Spoon, proving reuse rather than scene-specific anomaly state. |
| 27 | The Gift Test | `RELW + INT + BLF + EPS + CAU + PRS + PLY + ACTR` | **PASS + CONTENT** | Wilson creates deliberate test arrangement; animal theft can create false attribution because actual cause and inferred cause remain separate. |
| 28 | Miracle Fatigue | `BLF + INT + TRT + PRS + PLY + REACT` | **PASS** | Expected intervention and dependency produce waiting; failed expectation reduces dependency without rewriting independence. |
| 29 | Sabotaged Storage | `RELW + PRJ + BLF + EPS + HAB + CAU + PRS + PLY + REACT` | **PASS** | Broad integration reference. Storage truth, expected arrangement, displaced observations and attribution remain separate. No special sabotage flag. |
| 30 | The Unwanted Rescue | `PLY + INT + OUT + CAU + PRS + REACT` | **RESHAPED PASS** | Canonical version moves/removes support/target before commitment or otherwise preserves committed physics. Player intent remains private. |
| 31 | The Signal Fire | `DIR + ENV + PRJ + BLF + INT + PLY + OUT + EPS` | **PASS + CONTENT** | Boat is a rare event opportunity; Director biases signaling candidates but Wilson still chooses among them. |
| 32 | Not Now, Humanity | `DIR + DRV/HAB/EPS + INT + REACT` | **RESHAPED PASS** | Canonical replacement uses existing urgent/history-based pressure (e.g. Gerald/food), not a new toilet drive. Directed scene may legitimately break. |
| 33 | The Neighbor | `DIR + PLC + ENT + RELW + BODY + ASC + INT + EPS` | **PASS + CONTENT** | Temporary place/access event plus held/container relations handles carrying tradeoffs and souvenir provenance. |
| 34 | Captain Wilson | `DIR + PLC + ENT + AFF + INT + EPS + ASC` | **PASS + CONTENT** | Wreck is content/location; helm roleplay is low-utility affordance/intention. Rare ball joke remains presentation/content, not domain state. |
| 35 | The Statue of Gerald | `ASC + EPS + DRV + PRJ + ENT + RELW + ACTR` | **PASS** | Authored statue project becomes eligible from systemic Gerald history/attachment. Form authored; subject systemic. |
| 36 | Gerald Is Missing | `ACTR + BLF + EPS + ASC + INT + REACT` | **PASS** | Absence is expectation mismatch from recurring history, not a grief primitive. Negative valence + high attachment remains meaningful. |
| 37 | The Falling Palm | `ENV + ENT + RELW + BODY + INT + OUT + PLY + REACT` | **PASS + REFINEMENT** | Explicit body state + route-blocking relations + committed action boundary support near-death and intervention window. |
| 38 | The Brilliant Shortcut | `PLC + ENV + BLF + HAB + TRT + INT + BODY + OUT + PLY + RUN` | **PASS** | Changed wet/slippery world state alters perceived risk; death remains reconstructable from choice + grounded physical outcome. |
| 39 | I Hate Mushrooms | `RUN + BODY + BLF + ASC + REACT + PLY` | **PASS** | Resurrection hides explicit death source while retained danger belief/association regenerates fear. No trauma subsystem. |
| 40 | The Experiment | `RELW + INT + BLF + EPS + CAU + PRS + PLY + ACTR` | **PASS + CONTENT** | Deliberate arrangement/test + observation + false/true attribution composes from existing primitives. No direct-player-communication state needed. |

---

# 3. Coverage by domain family

The full catalog exercises the following domain families repeatedly.

| Domain family | Representative scenes | Regression conclusion |
|---|---|---|
| Entity properties/capabilities/interactions | 4, 5, 18, 20, 21, 22, 23, 34 | **Required core**; property-driven interaction is justified independently of crafting. |
| Stable places + spatial relations | 1, 3, 8, 15, 17, 26, 29, 33, 38, 40 | **Required core**; coordinates alone are insufficient for personal geography/history. |
| Environment/world processes | 16, 17, 18, 19, 24, 25, 31, 37, 38 | **Required core**; drying/spoilage/wind/fire/storm evolution should be reusable processes. |
| Wilson body/conditions | 5, 12, 16, 20, 21, 22, 37, 38, 39 | **Required core**; cognition/drives cannot own physical injury/death truth. |
| Lightweight persistent actors | 11, 12, 27, 35, 36 | **Required but narrow**; persistent identity + simple behavior is enough. |
| Beliefs/expectations | almost all | **Universal cognition substrate**. |
| Associations | 1, 3, 5, 10–12, 14–15, 17–18, 21–23, 26, 35–36, 39 | **Required personal continuity**. |
| Habits | 1–2, 8–9, 11, 21–22, 24–26, 29, 38 | **Required learned bias**, not a routine planner. |
| Episodes | most long-history scenes | **Selective continuity**, never full event log. |
| Intentional continuity/competition | all behavioral scenes | **Universal decision substrate**. |
| Projects | 9, 13–15, 17, 25, 29, 31, 35 | **Specialized first-class aggregate**. |
| Presence attribution/relationship | 6, 8–9, 26–30, 40 | **Product-specific required vertical**. |
| Director opportunities | 31–34 plus rare objects/areas | **Required bounded content layer**, never choice authority. |
| Run lifecycle | 38–39 | **Required explicit boundary**. |

---

# 4. Cross-scene compositional proofs

## 4.1 Expected relation reuse

The same domain mechanism supports several apparently unrelated stories:

```text
belief: expected_relation(subject, relation, object/place)
+
current perceived relation
→ prediction error
```

Used by:

- Missing Spoon — utensil not beside cooking area;
- Someone Moved the Rock — seat not at habitual place;
- Sabotaged Storage — materials not inside expected container;
- Interior Design — decorative arrangement differs from preferred/expected pattern;
- Inspection Day — expected fire state at bedtime.

No scene-specific `missing_spoon`, `moved_rock` or `storage_sabotaged` state is justified.

## 4.2 Instance relationship reuse

```text
SubjectRef(EntityId)
+ AssociationEntry
+ beliefs/history/habits
```

supports:

- favorite rock;
- hated fire pit;
- Gerald;
- bowling ball becoming favored tool;
- treasured souvenir.

No `favorite_object`, `rival`, `pet`, `grudge` or `ownership` primitive is necessary.

## 4.3 World-process reuse

```text
EnvironmentalProcess
→ property/relation/world event changes
```

supports:

- laundry drying/rain re-wetting;
- fruit spoilage;
- fire consuming fuel;
- storm moving objects;
- storm weakening palm;
- waves introducing/removing objects;
- wet trunk increasing slip risk.

These should not be implemented as Director events unless they are narratively exceptional versions of an ordinary process.

## 4.4 Partial-feedback reuse

```text
ActionOutcome.diagnostic_feedback
```

supports:

- wood breaking against container;
- metal container denting;
- umbrella turning inside out;
- sled not initially moving;
- tool being too short/soft/weak;
- project contribution partially succeeding.

This is essential to procedural experimentation because Wilson must be able to distinguish `nothing learned` from `failed, but informative`.

## 4.5 History-to-project reuse

```text
history/association/belief predicates
+ authored ProjectDefinition
→ ProjectOpportunity
```

supports:

- Gerald statue;
- better drying location after repeated rain;
- defensive storage improvements;
- improved signal preparation;
- safer route/path improvements.

The domain does not invent arbitrary project geometry; systemic history chooses when/for whom authored possibilities become meaningful.

---

# 5. Domain gaps found and resolved in this pass

The first `DOMAIN_MODEL.md` draft was insufficient in three areas. The catalog provided direct evidence for each refinement.

## 5.1 Wilson physical body state

### Gap

The draft had motivational drives but no authoritative representation for injury, poisoning, wetness, mobility or death progression.

### Evidence

Victory Lap, Mushroom, Faster Than Walking, Too Hot, Falling Palm, Brilliant Shortcut and I Hate Mushrooms.

### Resolution

Added `WilsonBodyState` + `BodyCondition` under world/physical authority.

No new psychological primitive was added.

## 5.2 Stable places and authoritative relations

### Gap

`WorldLocation` alone was too implementation-shaped and too weak to support personal geography, expected arrangements and semantic storage history.

### Evidence

Long Way Around, Missing Spoon, Interior Design, Someone Moved the Rock, Sabotaged Storage, Neighbor and Brilliant Shortcut.

### Resolution

Added `PlaceId`/`PlaceState`, `SubjectRef(Place)` and `WorldRelation`.

Expected arrangement remains a Wilson belief about world relations, not duplicated world truth.

## 5.3 Lightweight recurring actor state

### Gap

Entity identity existed, but no explicit minimal runtime behavior boundary for Gerald-style recurring animals.

### Evidence

Gerald, Victory Lap, Gift Test, Statue of Gerald and Gerald Is Missing.

### Resolution

Added `ActorProfileDefinition` + `ActorRuntimeState` with recurring identity and shallow behavior.

Wilson retains ownership of relationship meaning.

---

# 6. Stress tests against overengineering

## 6.1 No deep animal cognition required

Gerald scenes pass with:

```text
persistent EntityId
+ simple actor behavior
+ Wilson association/belief/history/habit
```

Therefore do not mirror `WilsonCognitionState` for animals.

## 6.2 No universal crafting graph required

Bowling Ball and Scientific Method pass with:

```text
property/capability interaction rules
+ semantic outcomes
+ authored transformations
+ learned semantic interactions
```

Therefore do not introduce a technology tree, recipe table or arbitrary procedural blueprint generator.

## 6.3 No global planner required

Roof or Table, Storm Priorities, Mushroom and Signal Fire pass through candidate competition among locally generated meaningful intentions.

Therefore no global GOAP task tree is required by the catalog.

## 6.4 No global mood required

Victory Lap, Gerald Is Missing, Fine!, Too Hot and I Hate Mushrooms pass with transient reactions regenerated from current cue + durable history.

## 6.5 No full physics simulation required

Falling Palm, Brilliant Shortcut and Bowling Ball require grounded physical semantics but not arbitrary rigid-body simulation of every object combination.

Domain requirements are semantic:

```text
capabilities/properties
+ spatial/context relations
+ action progression
→ grounded outcome
```

The implementation may use authored/approximate physics beneath this contract.

---

# 7. Remaining domain questions — not blockers yet

The regression does not justify additional broad primitives, but implementation-oriented modeling will eventually need to choose these representations:

1. **Spatial topology:** how `PlaceId`, navigation regions, local coordinates and route/hazard queries compose without making `Place` too coarse.
2. **Body ownership API:** World Simulation remains authoritative, but Action Resolution and slow physiology/environment processes both need explicit proposal/commit paths into `WilsonBodyState`.
3. **Actor behavior representation:** behavior rules/state machine/utility choice for animals remains implementation-neutral; the domain only requires shallow deterministic behavior with stable identity where recurring.
4. **Environmental process state:** some processes may be derived from properties/time rather than persisted process instances; persist only when interruption/resumption semantics require it.
5. **Predicate normalization:** the functional predicate algebra is intentionally broad; package design should split physical predicates from cognition/content eligibility queries so interactions do not accidentally become omniscient.
6. **Semantic concepts as subjects:** aesthetic colors/materials and abstract patterns may use `SemanticConcept` subject references; content validation must keep this vocabulary bounded.

None of these currently requires reopening product/behavioral discovery.

---

# 8. Functional-domain gate result

## Must-have scenes

All 23 Must-have scenes identified by `SCENE_VALIDATION.md` pass with reusable domain concepts.

## Strong scenes

All Strong scenes pass without new broad state primitives. Laundry, Victory Lap and related cases provided useful body/environment refinements.

## Expensive/Later scenes

Gift Test, Neighbor, Captain Wilson and The Experiment require authored content and presentation breadth but do not force new core domain families.

## Reshaped scenes

Unwanted Rescue and Not Now, Humanity pass under the already-canonical reshapes:

- preserve action commitment/causal coherence;
- use existing motivational/history pressures instead of proliferating drives.

## Conclusion

**Functional domain regression: PASS.**

The model is expressive enough to proceed to a second modeling pass focused on:

```text
aggregate invariants
commands/queries/domain services
state-transition schemas
predicate/effect taxonomy normalization
class responsibilities
orchestration-facing interfaces
```

This is still language-neutral. Package layout and GDScript/C# mechanics should remain deferred until those contracts are similarly regressed.