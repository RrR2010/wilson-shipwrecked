# Asset Catalog — Representative Scene Coverage

## Purpose

This document regression-checks the normalized cross-cutting asset catalog against the 40 historical representative scenes in `docs/brainstorming/representative-scene-catalog.md`.

The scene catalog is **behavioral/content evidence**, not a script catalog. A scene passes when the currently stabilized domain plus catalogued content can produce an equivalent player-visible chain through ordinary actions, world mutation, perception/evidence, cognition, projects, Director opportunities and presentation adapters.

This matrix distinguishes:

```text
PASS
  current domain + catalog content are sufficient

PASS / CONTENT EXTENSION
  domain is sufficient; a later/non-core content family or presentation binding is still needed

RESHAPE
  historical literal scene conflicts with a later canonical decision;
  the accepted phenomenon remains supported through its canonical reshape
```

---

# 1. Coverage matrix

| # | Scene | Result | Main catalog/domain support | Remaining note |
|---:|---|---|---|---|
| 1 | The Good Chair | PASS | `flat_rock`, `stool_crude`, `log_short`; sit affordance; persistent `EntityId`; association + habit | No content gap. |
| 2 | Breakfast First | PASS | food storage projects/containers, `fruit_generic`; habit + drive/intention competition | No content gap. |
| 3 | The Long Way Around | PASS | `place.tide_pool`, crab, route queries, place association/history | Avoidance is Wilson-relative, not a place hazard flag. |
| 4 | Scientific Method | PASS | `sealed_metal_container`, interaction regions, branch/stone/tool candidates, diagnostic feedback/evidence | Strong reference regression already supported. |
| 5 | The Perfectly Good Bowling Ball | PASS | `bowling_ball_rare`, generic impact semantics, effective mass/hardness, dynamic rolling | No coconut-specific interaction required. |
| 6 | Absolutely Not | PASS | any unfamiliar local entity + suggestion source + intention competition | “Mysterious object” need not be a dedicated family. |
| 7 | Fine! | PASS / CONTENT EXTENSION | suggestion/autonomy + ordinary possession relation + qualified body carry mode/slot | Add a P1 hat-like/wearable salvage content family if this scene is produced. `carried_by(item, Wilson)` may use a bounded qualifier for worn/body-slot mode; presentation adapter resolves the body transform. No equipment system required. |
| 8 | The Missing Spoon | PASS | `spoon_utensil`, stable placement relations, expectation mismatch, player relocation | Exact expected location remains belief/habit semantics. |
| 9 | The Benefactor | PASS | project material roles, player interventions, presence trust/dependency/expectation | No special “gifted resource” state. |
| 10 | The Traitorous Fire | PASS | `project.fire_site`, persistent physical site identity, fire process, association/history | Fire lifecycle stays world/environment truth. |
| 11 | Gerald | PASS | `animal.crab_recurring`, persistent `EntityId`, shallow actor steal/carry activity | Rivalry remains Wilson cognition. |
| 12 | Victory Lap | PASS | recurring crab, food, `terrain.shallow_hole`, movement/body consequence | Transient triumph/reaction does not require catalog state. |
| 13 | One More Piece | PASS | `project.shelter_basic`, interchangeable components, hunger drive, project continuation | Physical partial construction remains world truth. |
| 14 | Roof or Table? | PASS | shelter + `project.work_surface_basic`, shared component roles, competing projects | No resource reservation or optimal-choice rule required. |
| 15 | Interior Design | PASS / CONTENT EXTENSION | ordinary placement, association/aesthetic intention, persistent arrangements | Add reusable decorative shell/curio content plus a generic decorative-arrangement project/content pattern. |
| 16 | The Laundry Problem | PASS | `garment_cloth_basic`, `project.clothesline`, moisture + drying, rain/wind response | No laundry state machine required. |
| 17 | Storm Priorities | PASS | loose props, wind displacement, shelter/storage/protection, attachment value and intentions | Decorative-object breadth benefits from the Scene 15 extension. |
| 18 | The Umbrella | PASS | `umbrella_found`, deployable configuration, covering/protection, wind load | Failure is grounded component/configuration change. |
| 19 | Midnight Noise | PASS | ordinary attached loose object + auditory evidence + night perception + investigation | No dedicated “noisy object” family required; sound/contact evidence is a rule/presentation concern. |
| 20 | The Mushroom | PASS | `mushroom_generic`, hidden edibility/toxicity truth, evidence uncertainty, hunger/risk competition | No omniscient UI/property reveal. |
| 21 | Faster Than Walking | PASS | `sign_panel`/flat salvage candidate, sandy slope place properties, sliding `DynamicProcessState`, injury | Improvised sled is a configuration/use, not a vehicle recipe. |
| 22 | Too Hot | PASS | fire/cooking content, `pole_wood`/branch reach tools, prior body injury -> association/belief | Excess caution remains cognition, not heat-tool metadata. |
| 23 | The Bottle | PASS | `bottle_jar`, transparent/opaque evidence, closure/contents, unresolved intention | Strong evidence/exploration regression. |
| 24 | Rotten Luck | PASS | fruit freshness/spoilage, storage contents, hunger/project interruption | Spoilage is environmental world evolution. |
| 25 | Inspection Day | PASS | fire process, fuel entities, habit evidence and recurring check intention | No “inspection required” flag. |
| 26 | Someone Moved the Rock | PASS | `flat_rock`, stable place/placement expectation, player relocation, causal attribution | Preferred spot remains habit/association. |
| 27 | The Gift Test | PASS | fruit + flat support + deliberate arrangement + presence investigation semantics | Offering meaning is Wilson intention/proposition, not an object category. |
| 28 | Miracle Fatigue | PASS | generic heavy object, player intervention history, presence dependency/expectation | No special help-request object state. |
| 29 | Sabotaged Storage | PASS | containers, ordinary contents relations, project material roles, epistemic investigation | Canonical broad integration fixture. |
| 30 | The Unwanted Rescue | RESHAPE | intervention causal windows, action commitment, ordinary relocation | Original “target vanishes after physical reach commitment” is intentionally rejected. Canonical version changes target/support/route while the causal window is still open. |
| 31 | The Signal Fire | PASS / CONTENT EXTENSION | `project.fire_site`, fuel/smoke process, Director opportunity, competing intentions | Add a P0 Director-bound distant human-contact presentation/content family for boat/aircraft visibility. |
| 32 | Not Now, Humanity | RESHAPE | Director opportunity + normal autonomy/interruption | Original toilet-like need is intentionally excluded. Canonical replacement uses an admitted pressure/history such as Gerald threatening food. |
| 33 | The Neighbor | PASS / CONTENT EXTENSION | place/region refs, route connectivity, ordinary carrying/association/history | Domain supports it; later content needs neighboring-islet place + temporary-access presentation/topology binding. Appropriate P2/E scope. |
| 34 | Captain Wilson | PASS | `shipwreck_structural_section`, wreck access/climb regions, `buoy_life_ring`, ordinary salvage | Helm/cabin may be interaction regions/presentation on the wreck rather than standalone systems. |
| 35 | The Statue of Gerald | PASS / CONTENT EXTENSION | generic project semantics, stone/shell placement, persistent arrangement, Gerald association/history | Add generic decorative/sculptural arrangement pattern; do not add `project.gerald_statue` as a core primitive. |
| 36 | Gerald Is Missing | PASS | recurring crab identity, expected place/activity, absence evidence, association | Absence is Wilson-relative expectation mismatch, not `animal_missing` state. |
| 37 | The Falling Palm | PASS | palm, storm weakening, `DynamicProcessState`, perceived threat, causal intervention window, body effects | Canonical hazard fixture. |
| 38 | The Brilliant Shortcut | PASS | `log_long` crossing, wet/slippery place/profile semantics, cargo, route alternatives, body/death lifecycle | Death remains grounded and reconstructable. |
| 39 | I Hate Mushrooms | PASS | mushroom identity/category + resurrection persistence + association/belief asymmetry | Fear/aversion survives through cognition contract, not entity metadata. |
| 40 | The Experiment | PASS | ordinary movable objects, deliberate arrangement, expectation comparison, presence attribution, player relocation | No fourth-wall entity or explicit player identity required. |

---

# 2. Content extensions exposed by the scenes

These are **catalog/content follow-ups**, not domain-system gaps.

## 2.1 Wearable / hat-like salvage

Scene 7 needs a recognizable small found object that Wilson can put on his head/body and remove/drop.

The authoritative world representation does not require a new relation family:

```text
carried_by(item, Wilson)
  qualifier = bounded semantic carry mode/body slot
```

This follows the canonical relation rule that manipulation/slot detail may be expressed by a qualifier when a narrower relation is unnecessary.

A presentation/body adapter maps that semantic slot to a concrete transform. A generic `wear`/`remove` action definition may create/remove/change the qualified possession relation without introducing an equipment aggregate.

Content still needs a later P1 family such as a hat-like piece of debris if the scene is produced.

## 2.2 Decorative shell / small curio grammar

Scenes 15 and 35 need a cheap reusable small decorative object family that can accumulate personal significance while obeying ordinary physical rules.

Preferred shape:

```text
shell_decorative
  EntityDefinition
  low mass / small bulk
  graspable
  carry / put / inspect
  ordinary on_top_of placement
  persistent recognizable variants
```

Do not add capabilities such as `favorite`, `collectible`, `beautiful` or `Gerald_statue_material`. Those meanings emerge from content metadata, Wilson association/intention and arrangement history.

A shell may originate naturally at the shore or as a shellfish transformation by-product.

## 2.3 Generic decorative/sculptural arrangement pattern

Scenes 15 and 35 expose a reusable project/intention pattern:

```text
arrange ordinary persistent objects
into a desired spatial/aesthetic pattern
across multiple contributions
```

Use a generic decorative-arrangement `ProjectDefinition`/content pattern when persistence and multiple work sessions justify a project.

Possible roles:

```text
role.decorative_piece
role.support_or_site
optional authored arrangement/shape target
```

Physical truth remains ordinary entity positions/relations. Project completion reads grounded arrangement state.

For a small one-session arrangement such as Scene 40, the same actions may occur under an ordinary semantic intention without a project instance.

## 2.4 Distant human-contact opportunity presentation

Scene 31 is Must-have behavioral evidence but the catalog still lacks the modeled-content/presentation requirement for the distant contact itself.

Add a P0 **Director-bound presentation/content family**, not a fake local interactable resource:

```text
directed.distant_human_contact
  DirectedEventDefinition / presentation binding
  variants: boat / aircraft
  distant trajectory / visibility window
  perceptual evidence: visible/audible cues
  no automatic rescue result
```

Wilson interacts indirectly through existing local physical actions such as increasing signal-fire visibility or moving into a signaling location.

Do not create `rescue_meter`, `humanity_progress` or hidden Wilson-facing omniscience unless a concrete event-local state later proves necessary.

## 2.5 Neighboring islet / temporary access

Scene 33 is Expensive/Later and does not block P0/P1 production. The domain already admits `Place`, `Region`, `connects`, route queries and environmental opportunity changes.

Future P2 content can add:

```text
place.neighbor_islet
temporary access topology/presentation
  e.g. sandbar / tide window / exposed crossing
```

---

# 3. Historical scenes intentionally not reproduced literally

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

The original invents a toilet-like urgency solely to interrupt a directed event. Later behavioral validation intentionally rejected that drive expansion.

Supported equivalent:

```text
rare human-contact opportunity
+ admitted ordinary pressure/history
→ Wilson may still miss/break the directed scene
```

Preferred interruptions include Gerald threatening exposed food, admitted urgent body/drive pressure, storm/project consequence or another high-salience anomaly.

The Director biases opportunity; it never suspends ordinary autonomy to protect a scene.

---

# 4. Game-loop coverage by phenomenon family

## 4.1 Quiet routine / preference

Examples: Good Chair, Breakfast First, Inspection Day, Gerald Is Missing.

```text
world/perception
→ habit/association/expectation becomes salient
→ ordinary intention candidate
→ choice against competing drive/opportunity
→ physical action
→ persistent placement/history remains visible
```

**PASS.**

## 4.2 Physical experimentation / discovery

Examples: Scientific Method, Bowling Ball, Mushroom, Bottle, Faster Than Walking.

```text
perception/evidence
→ speculative tactical opportunity
→ attemptability
→ committed action
→ physical outcome + diagnostic feedback
→ perception/evidence
→ immediate relevant learning
→ next tactic or intentional reconsideration
```

**PASS.**

## 4.3 Project continuation / competition

Examples: One More Piece, Roof or Table?, shelter/weather, statue/decoration.

```text
ProjectDefinition opportunity/current project
→ grounded contribution candidate
→ ordinary action
→ world component mutation
→ project reads grounded outcome
→ pause/continue/complete competes with ordinary life
```

**PASS**, with decorative content extension for Scenes 15/35.

## 4.4 Player intervention / unseen presence

Examples: Missing Spoon, Benefactor, Moved Rock, Gift Test, Miracle Fatigue, Sabotaged Storage, Experiment.

```text
validated intervention
→ world mutation
→ changed world / WorldEvent
→ Wilson-accessible perception
→ expectation mismatch / evidence
→ causal attribution
→ belief/presence/association updates
→ later behavior changes
```

**PASS.**

## 4.5 Living actors / persistent individual relationship

Examples: Gerald, Victory Lap, Gerald Is Missing.

```text
shallow actor local behavior
+ persistent EntityId where recurring
→ Wilson perception/history
→ association/belief/habit
→ later expectation/reaction
```

**PASS.**

## 4.6 Environment / ordinary world evolution

Examples: Laundry Problem, Rotten Luck, Storm Priorities, Umbrella, Midnight Noise.

```text
time/environment
→ EnvironmentalResponseRule/process
→ grounded property/relation/spatial change
→ visible presentation/evidence
→ Wilson response/adaptation
```

**PASS.**

## 4.7 Immediate hazard / death

Examples: Falling Palm, Brilliant Shortcut.

```text
world process becomes hazardous
→ accessible warning evidence
→ PerceivedThreat
→ immediate-threat action selection
→ causal boundary / intervention window
→ collision/body consequence
→ death/resurrection lifecycle if lethal
```

**PASS.**

## 4.8 Directed opportunity without cutscene protection

Examples: Signal Fire, reshaped Not Now Humanity.

```text
Director activates bounded opportunity
→ perceptual evidence / salience bias
→ Wilson intention competition remains ordinary
→ local physical signaling actions
→ event resolves/expires independently
```

**DOMAIN PASS / CONTENT EXTENSION** because the distant-contact presentation family is not yet explicit in the catalog.

---

# 5. Final gate

Against the entire 40-scene historical suite:

```text
Domain/systemic loop:
  PASS for all accepted representative phenomena

Literal historical scene text:
  38/40 compatible with stabilized direction
  2/40 intentionally RESHAPED (30, 32)

Current normalized catalog:
  broad PASS
  + 4 localized content extensions:
      wearable/hat-like salvage
      decorative shell/curio family
      decorative/sculptural arrangement pattern
      distant human-contact Director presentation family
  + 1 deferred additional-location extension
```

No representative scene now demonstrates a missing **broad** domain primitive.

The review does **not** justify another state owner, crafting system, equipment system, scene-scripting layer or interaction recipe catalog.

The strongest conclusion is that the proposed domain and micro-loop compose the representative scenes well. Remaining shortcomings are content vocabulary and presentation bindings, which is the desired failure mode for a stabilized systemic domain.
