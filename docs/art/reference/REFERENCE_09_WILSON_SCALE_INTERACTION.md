# Reference 09 — Wilson Scale & Interaction

## Purpose

Define Wilson's production-facing scale, proportion and interaction-readability rules without prematurely finalizing his character design.

This document exists so environment/prop agents can model against a stable human scale and interaction vocabulary while Wilson's final identity remains subject to explicit review.

---

# 1. Character direction

Wilson should read as:

- adult;
- competent but physically fallible;
- stylized and caricatured;
- approachable rather than gothic or grotesque;
- less aggressively faceted than the environment;
- expressive at the canonical gameplay camera;
- compatible with reusable generic interactions.

Avoid:

- extremely thin limbs;
- oversized skull-to-body ratios that push toward gothic caricature;
- hyperreal anatomy;
- anime-specific proportions;
- toy-chibi proportions;
- excessive facial detail that disappears at gameplay distance.

The environment may be aggressively low-poly. Wilson should share the same material/rendering world while using smoother shape transitions.

---

# 2. Production mannequin first

Before final character sculpting, maintain a neutral Wilson mannequin as the authoritative scale comparator.

The mannequin must expose:

```text
HEIGHT_REFERENCE
HEAD_REFERENCE
HAND_L
HAND_R
FOOT_L
FOOT_R
HIP
CHEST
SHOULDER_L
SHOULDER_R
```

and production attachment anchors:

```text
ANCHOR_HAND_L
ANCHOR_HAND_R
ANCHOR_CARRY_CENTER
ANCHOR_BACK
ANCHOR_HEAD
ANCHOR_WAIST
ANCHOR_FOOT_L
ANCHOR_FOOT_R
```

The mannequin should be deliberately simple and must not be mistaken for final Wilson art.

---

# 3. Relative proportion target

Exact numbers should be calibrated in the gameplay scene, but use these directionally:

- total height: adult human scale in world units;
- head: moderately enlarged for readability, not giant;
- hands: clearly oversized enough for manipulation readability;
- feet: slightly enlarged for grounded poses;
- torso: compact and readable;
- limbs: short-to-medium stylization, not spindly;
- shoulders/hips: enough mass to support readable carries and tool swings.

A reasonable exploration band for head size is approximately 1.2–1.4× a realistic adult proportion, subject to visual review.

Do not optimize the character for portrait shots. Optimize for gameplay distance.

---

# 4. Silhouette priorities

Wilson's silhouette should remain recognizable when:

- standing idle;
- walking;
- carrying one-handed object;
- carrying large two-handed object;
- sitting;
- crouching/inspecting;
- swinging a tool;
- sleeping/lying down.

Hair, head, torso and hand masses should provide enough visual identity that these poses do not collapse into a generic stick figure.

---

# 5. Faceting policy

Wilson uses lower apparent faceting than environment assets.

Preferred:

- simple rounded head mass with controlled planar transitions;
- torso/limbs built from low-detail forms with selective smooth shading;
- hands as simplified readable mitten/block forms rather than finger-heavy meshes;
- feet as simple stable masses;
- hair as one primary mass plus a few major tufts.

Avoid:

- high-density topology hidden by smooth shading;
- random angularity across the face;
- faceted cheekbones/jaw so strong that Wilson reads as harsh or gothic;
- detailed fingers that are invisible at gameplay scale.

---

# 6. Material policy

Wilson should remain compatible with the project's texture-light pipeline.

Default expectation:

- shared flat-color materials for skin, hair, shirt, shorts/trousers, footwear;
- no unique skin texture;
- no fabric weave;
- no painted dirt atlas as baseline;
- simple roughness differences only where useful.

Potential exceptions later:

- a small shared face/decal solution for eyes/mouth if geometry alone is insufficient;
- rare semantic clothing marking;
- bounded shared dirt/wetness shader state.

Any character-specific texture must justify its production/runtime cost.

---

# 7. Color hierarchy

Wilson should remain visually separable from common environment masses.

Guidelines:

- avoid clothing colors that disappear into dominant sand/foliage values;
- preserve enough value contrast around head/hands;
- avoid making Wilson the most saturated object in every scene;
- fire, rare objects and strong events must still be able to steal focal priority temporarily.

Wilson should be easy to locate without becoming a UI marker.

---

# 8. Interaction height vocabulary

Props and anchors should align to a small set of reusable interaction heights.

Suggested categories:

```text
GROUND
LOW
MID
HIGH
OVERHEAD
```

Approximate semantic uses:

## GROUND

- pick object from floor;
- place object;
- dig;
- inspect low item.

## LOW

- crate lid;
- stool;
- low storage;
- fire interaction.

## MID

- workbench;
- table;
- shelf;
- general manipulation.

## HIGH

- hanging storage;
- raised fruit;
- shelter attachment;
- clothesline.

## OVERHEAD

- climb/reach special cases;
- high shelter work;
- palm/branch interaction.

Avoid creating bespoke character poses for every centimeter of height difference.

---

# 9. Reach envelope

Environment agents should model interaction surfaces with Wilson's reusable reach envelope in mind.

Reference sheet should visualize:

- comfortable one-hand reach;
- comfortable two-hand reach;
- crouched reach;
- overhead reach;
- large-object carry clearance.

Objects may exaggerate size/height slightly to fit these envelopes.

Gameplay readability and animation reuse outrank strict realism.

---

# 10. Handheld object scale

Small objects should not become visually tiny simply because their real-world dimensions are small.

Examples that may be exaggerated:

- spoon;
- knife;
- coconut;
- cup;
- small stone;
- fruit;
- rope coil;
- tool head.

A handheld object should normally remain identifiable next to Wilson's hand from the canonical camera.

Do not exaggerate every object equally; preserve relative categories.

---

# 11. One-handed carry grammar

Suitable for:

- fruit;
- coconut;
- small container;
- small tool;
- stone;
- bottle;
- small salvage.

Assets should provide a semantic grip/attachment point when their orientation matters.

Suggested anchor:

```text
ANCHOR_GRIP
```

Do not require exact finger geometry.

---

# 12. Two-handed carry grammar

Suitable for:

- log;
- crate;
- large rock;
- barrel-like object;
- large debris;
- awkward rare object such as bowling ball.

Possible object anchors:

```text
ANCHOR_GRIP_L
ANCHOR_GRIP_R
ANCHOR_CARRY_CENTER
```

Large objects should clearly communicate weight through size and posture, not through texture/detail.

---

# 13. Tool interaction grammar

Tools should be compatible with generic poses:

- inspect;
- hold idle;
- swing/chop;
- hammer/strike;
- dig;
- pry;
- carry.

A tool family should expose stable grip orientation and working-end direction.

Recommended semantic nodes:

```text
ANCHOR_GRIP
ANCHOR_WORK_END
```

The Tool Grammar reference remains authoritative for tool construction language.

---

# 14. Seating

Seating surfaces should be validated against Wilson's pelvis/foot placement rather than realistic furniture standards.

Reference categories:

```text
LOW_SEAT
NORMAL_SEAT
GROUND_SEAT
```

Examples:

- flat rock;
- log;
- stump;
- crude stool;
- bench;
- hammock.

Seat assets should expose:

```text
ANCHOR_SIT
```

Optional orientation marker:

```text
ANCHOR_SIT_FORWARD
```

This is particularly important because preferred sitting locations may acquire behavioral meaning.

---

# 15. Sleeping

Sleeping objects should support a small vocabulary:

- ground sleep;
- mat/bedroll;
- shelter sleeping area;
- hammock.

Suggested nodes:

```text
ANCHOR_SLEEP
ANCHOR_SLEEP_FORWARD
```

Bedding scale should prioritize readable pose clearance rather than real-world compactness.

---

# 16. Work surfaces

Tables, flat rocks, stumps and benches should share compatible interaction logic.

Preferred surface height should fall within the MID interaction band unless intentionally specialized.

Possible nodes:

```text
ANCHOR_WORK
SOCKET_WORK_ITEM_01...
```

A workbench should feel more useful because of stability, organization and attachments, not because it has a unique menu-specific animation.

---

# 17. Containers and storage

Storage should expose interaction locations that prevent Wilson from clipping deeply into the asset.

Suggested nodes:

```text
ANCHOR_APPROACH
ANCHOR_OPEN
ANCHOR_REACH
SOCKET_CONTENT_01...
```

For raised/hanging storage, interaction height should align to HIGH rather than requiring unique animation.

---

# 18. Structures

Large structures should provide clear approach and task anchors.

Typical examples:

```text
ANCHOR_APPROACH
ANCHOR_BUILD
ANCHOR_REPAIR
ANCHOR_INSPECT
ANCHOR_ENTER
ANCHOR_SLEEP
```

Anchors must remain reachable throughout relevant construction stages.

Partially built structures should not place required interaction targets inside impossible geometry.

---

# 19. Climbable objects

Climbing should be treated as a special family rather than assumed from all vertical geometry.

Possible assets:

- palm;
- ladder;
- lookout structure;
- selected wreck geometry.

Suggested nodes:

```text
ANCHOR_CLIMB_START
ANCHOR_CLIMB_END
```

Intermediate climb logic may be runtime-driven; art should preserve clear start/end locations and silhouette.

---

# 20. Wilson and props in the reference sheet

The Wilson Scale & Interaction sheet should show the mannequin next to:

- coconut;
- spoon/cup;
- axe/hammer;
- crate;
- stool;
- table/workbench;
- log;
- barrel;
- shelter post/door opening;
- palm;
- hammock;
- raft edge.

Include interaction poses or pose mannequins for:

```text
stand
GROUND reach
LOW reach
MID reach
HIGH reach
sit
one-hand carry
two-hand carry
tool swing
```

The sheet is a scale/interoperability reference, not a final character concept sheet.

---

# 21. Gameplay-camera tests

Wilson and interaction props must be reviewed at canonical camera distance.

Test:

- can Wilson be located immediately?
- are hands/tools readable?
- is the action recognizable without zoom?
- do important props remain distinguishable?
- do contact points appear plausible?
- does Wilson visually belong to the same world while remaining softer than the environment?

Reject interaction assets that work only in close-up.

---

# 22. Performance and production constraints

Character production should preserve simplicity:

- no geometry hidden purely for close-up beauty;
- limited material slots;
- reusable rig/animations;
- semantic attachment anchors;
- no object-specific character mesh variants unless essential;
- clothing should initially remain simple and rig-friendly.

Animation reuse is a primary art constraint.

---

# 23. Final Wilson design boundary

This document does not authorize autonomous finalization of Wilson's face, hair identity, exact clothing design or final proportions.

The production mannequin and interaction envelope may be finalized first.

Final character identity requires explicit visual review because Wilson is the focal character and errors cannot be hidden through procedural variation.

---

# 24. Acceptance criteria

Approve a scale/interaction reference only if:

- environment assets align to reusable interaction heights;
- props remain identifiable at gameplay distance;
- one-hand/two-hand carry classes are visually coherent;
- seating and sleeping surfaces fit the mannequin;
- construction anchors remain accessible;
- Wilson reads as a softer caricature than the aggressively faceted environment;
- material treatment remains texture-light;
- the sheet can be used directly by an independent modeling agent without inventing new scale assumptions.
