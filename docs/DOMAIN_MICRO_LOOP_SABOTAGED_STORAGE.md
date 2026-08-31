# Sabotaged Storage — Epistemic Micro-Loop

## Status and purpose

This document is a canonical functional-domain regression fixture for representative Scene 29, `Sabotaged Storage`.

It stress-tests the domain path where the important hidden fact is not a physical property but **causation**:

```text
private player action
→ authoritative world mutation while Wilson is absent
→ later expectation mismatch
→ bounded investigation
→ multiple observations
→ competing causal hypotheses
→ attribution
→ reaction
→ owner-local learning
→ changed future behavior
```

The fixture must preserve the core epistemic invariant:

```text
actual cause != observed result != Wilson-attributed cause
```

No private player intent or unobserved intervention identity may enter Wilson cognition.

---

# 1. Canonical setup

## World truth before sabotage

```text
storage_01
  capability.container
  place = camp_storage_area

plank_11 inside storage_01
rope_04 inside storage_01
stone_head_07 inside storage_01

shelter_area
beach_area
favorite_rock_area
```

## Wilson cognition before sabotage

Wilson has ordinary proposition-backed expectations such as:

```text
inside(plank_11, storage_01)       confidence high
inside(rope_04, storage_01)        confidence high
inside(stone_head_07, storage_01)  confidence high

storage_01 is usually reliable
retrieving project materials from storage_01 normally succeeds
```

He may also have a habit cue:

```text
project needs stored material
→ retrieve from storage_01
```

Presence relationship may be weak, moderate, positive or negative depending on prior run history. The fixture does not assume a specific prior.

---

# 2. Offscreen player intervention

While Wilson is asleep/absent, the player performs validated interventions:

```text
MoveEntity(plank_11, shelter_area)
MoveEntity(rope_04, beach_area)
MoveEntity(stone_head_07, favorite_rock_area)
```

World authority applies the changes and may emit world events.

Wilson is not an observer.

Therefore the following are invalid:

```text
ObservedEvent(player_moved_plank)
BeliefEvidence(player_caused_storage_change)
PresenceEvidence(player_sabotaged_storage)
trust -= ... immediately
```

No cognition mutation occurs merely because the player acted.

---

# 3. Frame-group boundary rule

A frame group ends when one of these becomes semantically meaningful:

```text
expected fact is contradicted by current perception
new related evidence is discovered
search tactic completes/fails
causal hypothesis ranking changes materially
reaction meaning changes materially
investigation intention completes/escalates/abandons
new player intervention changes currently observable evidence
```

Minor locomotion/render frames do not create separate decision cycles.

---

# 4. FG0 — Project need activates familiar retrieval routine

Wilson intends to continue a project requiring `rope_04`.

Relevant cognition:

```text
current intention = continue project
habit/source = retrieve needed material from storage
expected relation = inside(rope_04, storage_01)
```

Tactical candidate:

```text
retrieve rope_04 from storage_01
```

No broad decision is required if the project remains coherent.

---

# 5. FG1 — Expected material absent

Wilson opens/inspects storage.

World truth:

```text
rope_04 not inside storage_01
```

Perception can establish only accessible current facts:

```text
storage visible/open
expected rope not observed among contents
other expected arrangement details may mismatch
```

Expectation comparison produces a derived contradiction:

```text
ExpectationMismatch
  expected_proposition: inside(rope_04, storage_01)
  observed_support: absent/not observed under sufficient inspection
  confidence: HIGH
  mismatch_kind: EXPECTED_PRESENT_BUT_ABSENT
```

Important:

```text
not observed under weak access != proven absent
```

Absence evidence requires an observation context whose coverage is sufficient for the proposition being tested.

This fixture therefore requires explicit **negative-evidence coverage semantics**.

---

# 6. New derived contract — ObservationCoverage

Some propositions can be contradicted only when Wilson inspected enough of the relevant domain.

```text
ObservationCoverage
  scope: DomainSubjectRef / semantic relation domain
  modality
  coverage_class: LOW | MEDIUM | HIGH | EXHAUSTIVE_FOR_QUERY
  occlusion/uncertainty diagnostics
```

Examples:

```text
quick glance into cluttered crate
→ LOW/MEDIUM coverage
→ missing rope is weak negative evidence

careful inspection of small open crate
→ EXHAUSTIVE_FOR_QUERY(contains rope-sized visible item)
→ strong evidence rope is absent
```

`ObservationCoverage` is derived and temporary.

It prevents the simulation from treating all non-observation as authoritative absence.

---

# 7. FG2 — Anomaly case opens

The first strong mismatch creates a temporary investigation context.

```text
InvestigationContext
  subject/problem: storage_01 arrangement anomaly
  originating_expectation_refs
  collected_evidence_refs
  active_hypotheses
  recent_search_tactics
  unresolved_questions
```

This is bounded, short-lived derived/working context.

It is **not** automatically an Episode, grievance, persistent suspicion meter or new state-owning system.

Initial hypotheses may include:

```text
H1 self misplaced / memory wrong
H2 ordinary physical displacement
H3 known animal/actor interference
H4 unknown ordinary agent/cause
H5 unseen presence
```

At this stage, one missing item should normally leave several hypotheses plausible.

---

# 8. FG3 — Search as information-gathering tactic

Tactical scope remains compatible with the higher-level project intention:

```text
recover needed material / understand missing storage item
```

Candidates may include:

```text
search near storage
inspect ground/nearby surfaces
check habitual alternate placement
use substitute material
abandon/postpone project
```

A search tactic can score for both:

```text
material recovery value
+
expected information gain
```

The cognition layer may estimate information gain from what a tactic could discriminate among current hypotheses.

Example:

```text
search immediately around storage

if found fallen beside crate:
  supports ordinary displacement

if found in Wilson's normal work area:
  supports self-misplacement

if absent locally:
  weakens simple local-displacement hypotheses
```

This does not require Bayesian exact math; bounded qualitative support is sufficient.

---

# 9. FG4 — First displaced item found beside shelter

Wilson finds `plank_11` beside the shelter.

Perception establishes:

```text
plank_11 at shelter_area
plank_11 not where expected
```

The investigation context appends evidence.

Possible interpretation:

```text
self-misplacement remains plausible
project/work carryover plausible
ordinary displacement possible
unseen presence weakly possible
```

The important behavior is that finding one item does **not** immediately force the presence hypothesis.

Wilson may recover the item and continue searching for the needed rope.

---

# 10. FG5 — Second item near beach

Wilson finds `rope_04` near the beach.

Now the pattern is stranger because:

```text
different stored items
→ displaced to different semantically unrelated places
```

The investigation context can derive a **pattern feature** from multiple evidence items:

```text
AnomalyPattern
  repeated_subject_family = stored materials
  displacement_count = 2
  destinations_not_same
  ordinary_local_spill_explanation = weaker
  coordinated_agent_explanation = stronger
```

`AnomalyPattern` is derived from evidence; it is not a durable global pattern store by default.

Wilson has recovered the immediate project material, so two branches become valid:

```text
A. resume project; unresolved anomaly may be admitted later as episode
B. curiosity/suspicion wins and investigation continues
```

The canonical scene follows B.

---

# 11. FG6 — Third item on favorite rock

Wilson discovers `stone_head_07` on his favorite rock.

This matters more than arbitrary distance because the destination is semantically meaningful to Wilson.

Inputs available to cognition may include:

```text
association(favorite_rock_area)
habit/history of using that place
belief that storage items do not normally belong there
```

The evidence now supports a stronger pattern:

```text
multiple expected-storage violations
+
multiple separated destinations
+
one personally salient destination
+
no witnessed ordinary cause
```

This may materially increase the hypothesis weight for:

```text
unknown agent
unseen presence
```

without proving either.

---

# 12. Causal hypothesis evaluation

A causal hypothesis should be explainable as bounded evidence support/opposition rather than one opaque score.

```text
CausalHypothesis
  cause_class
  subject_ref?             // when a known actor/presence is hypothesized
  supporting_evidence_refs
  opposing_evidence_refs
  prior_support
  current_support
  unresolved_conflicts
```

Candidate cause classes remain:

```text
SELF
KNOWN_ACTOR
NATURAL_PROCESS
UNKNOWN_ORDINARY_CAUSE
UNSEEN_PRESENCE
```

Useful contribution dimensions include:

```text
prior plausibility
opportunity/access plausibility as Wilson knows it
pattern fit
physical-explanation fit
semantic/personal targeting fit
history similarity
contradictory evidence
```

Critical authority rule:

```text
actual intervention provenance
must not enter hypothesis scoring
unless Wilson perceived evidence that exposes it
```

The optional LLM may only reweight/interpret already admitted hypotheses from Wilson-visible evidence.

---

# 13. Opportunity reasoning must also be Wilson-relative

Wilson may ask implicitly:

```text
could Gerald have reached this storage?
could wind have moved these objects?
could I have carried this here earlier?
```

Those questions must use a Wilson-relative causal opportunity projection, not omniscient history.

```text
PerceivedCausalOpportunity
  candidate cause
  relevant time/window
  plausibility from Wilson-known movement/capabilities/context
```

Examples:

```text
Gerald known near beach but not known to move heavy stone head
→ mixed/low support

storm/wind known absent overnight
→ natural wind explanation weakened

Wilson has no episode of using favorite rock for storage
→ self-misplacement explanation weakened
```

This contract is derived and temporary.

---

# 14. FG7 — Attribution becomes presence-leaning

After enough pattern evidence, a reasonable selected attribution may be:

```text
AttributionResult
  primary = UNSEEN_PRESENCE
  confidence = MODERATE
  alternatives = {SELF low, UNKNOWN_ORDINARY_CAUSE medium-low, ...}
```

The exact winner remains history-dependent.

Valid variations:

```text
Wilson blames himself first
Wilson suspects Gerald if history makes that plausible
Wilson leaves cause unresolved
Wilson already strongly believes in Presence and attributes earlier
```

No canonical scene flag forces Presence.

---

# 15. FG8 — Reaction derives from attributed meaning

Reaction depends on more than displacement.

Inputs:

```text
current project interruption
recovery effort
personal arrangement violation
selected causal attribution
prior association/trust toward Presence
```

Possible transient reaction:

```text
frustration
anger
suspicion
surprise
```

If the attribution targets Presence, anger can visually orient outward / toward the implied external agent.

Reaction remains transient.

There is no persistent `anger_at_player` meter.

---

# 16. FG9 — Learning proposals

From the same grounded evidence/attribution context, learning may propose independently:

```text
BeliefEvidence
  storage_01 arrangement is less reliable than expected

BeliefEvidence
  unexplained deliberate-like displacement is possible

PresenceEvidence
  existence/plausibility contribution positive
  subjective consequence harmful/frustrating
  trust contribution negative

EpisodeCandidate
  repeated unexplained storage displacement

HabitEvidence
  inspect storage before relying on it
  restore/secure important materials after anomaly
```

Important independence:

```text
presence_belief may rise
while
trust falls
```

There is no requirement that trust and belief move in the same direction.

Also:

```text
player intent = joke/help/test
```

never enters this update.

---

# 17. FG10 — Adaptation candidates

Later intentional/tactical candidate generation may naturally expose:

```text
relocate storage
build/upgrade covered or secured storage
keep valuable tools in a habitual personal location
inspect storage before project retrieval
recover displaced materials immediately
hide an important object
```

These arise from:

```text
changed beliefs
+ associations
+ habits
+ project definitions
+ ordinary affordances
```

not from:

```text
sabotaged_storage_mode
player_grudge_system
secure_storage_unlock_flag
```

---

# 18. Player continuation during investigation

The player may intervene again while Wilson is searching.

Examples:

```text
move another item
return an item
place compensation
move object Wilson is currently approaching
```

Causal rules:

- intervention mutates world first;
- Wilson receives only subsequent accessible evidence;
- a new intervention can change the active InvestigationContext only through perception;
- if Wilson directly witnesses an anomalous relocation, evidence quality for agency/presence may be much stronger than an offscreen result;
- private player intent remains inaccessible.

This allows the player to escalate, repair or confuse the story without a dialogue channel.

---

# 19. Diminishing repetition and evidence diversity

Repeated identical sabotage should not produce unlimited relationship mutation.

The learning layer should distinguish:

```text
repeated evidence of same already-established claim
vs
novel discriminating evidence
```

Example:

```text
10th identical missing spoon
→ small marginal presence-belief update

first witnessed impossible relocation
→ potentially much stronger evidence
```

This uses existing saturation/contradictory-evidence guards; no dedicated sabotage counter is required.

---

# 20. Persistence policy

Persist only admitted durable outcomes:

```text
belief updates
presence relationship updates
selected episode if admitted
habit changes if reinforced
world arrangement after Wilson/player actions
```

Do not persist by default:

```text
InvestigationContext
ObservationCoverage
AnomalyPattern
PerceivedCausalOpportunity
full causal hypothesis working set
transient reaction
```

If a save occurs mid-investigation, it is acceptable either to serialize a minimal resumable intention/working context or reconstruct it from current intention + recent bounded causal refs, depending on final persistence implementation. It must not require a permanent suspicion subsystem.

---

# 21. Debug requirements

A trace must answer:

```text
What did Wilson expect to find?
Was non-observation strong enough to count as absence evidence?
Which observations belong to this anomaly investigation?
Why did Wilson keep searching after recovering the immediately needed item?
What pattern was derived across displaced items?
Which causal hypotheses were considered?
What evidence supported/opposed each hypothesis?
Was causal opportunity evaluated from Wilson knowledge or omniscient history?
Why did Presence become more plausible, if it did?
Why could presence belief rise while trust fell?
Which future behavior changed because of durable learning?
```

---

# 22. Regression variants

## 22.1 Wilson blames himself

If prior memory confidence is weak or he commonly leaves materials around:

```text
SELF wins initially
```

Later discoveries may reverse it.

PASS if contradictory evidence can revise attribution.

## 22.2 Gerald is plausible

If Gerald has previously moved compatible objects and was recently observed nearby:

```text
KNOWN_ACTOR(Gerald)
```

may lead.

PASS if Presence is not privileged by architecture.

## 22.3 Natural explanation

If a storm occurred and objects are lightweight/displaceable in physically plausible directions:

```text
NATURAL_PROCESS
```

may remain strongest.

PASS if Wilson uses known environmental evidence rather than actual intervention metadata.

## 22.4 Player returns everything before discovery

Wilson sees normal expected arrangement.

```text
no mismatch
→ no investigation
→ no attribution
```

PASS.

## 22.5 Player moves an item while Wilson watches

Wilson perceives an otherwise unexplained relocation.

Evidence for unknown agency/Presence can become much stronger.

Still:

```text
Observed relocation != knowledge of private player intent
```

PASS.

---

# 23. Result

**PASS with epistemic refinements.**

The scene requires no new state-owning subsystem.

The reusable refinements exposed are:

```text
ObservationCoverage
InvestigationContext
AnomalyPattern
PerceivedCausalOpportunity
explicit evidence support/opposition on CausalHypothesis
information-discrimination value for investigation tactics
```

All are derived/working contracts except already-admitted durable learning outcomes.
