# Procedural Weather Domain

## Status and purpose

This document records the implemented procedural-weather boundary for Wilson Shipwrecked.

It complements:

- `DOMAIN_ENVIRONMENTAL_PROTECTION.md`;
- `DOMAIN_FIXTURE_CLOTH_SHELTER_WEATHER.md`;
- `DOMAIN_PROCEDURAL_COMPOSITION.md`;
- `SIMULATION_ORCHESTRATION.md`.

Weather is an authoritative World process. It does not directly own entity behavior, Wilson behavior, shelter behavior, damage behavior, or perception policy.

---

# 1. Authoritative ownership

`EnvironmentState` remains the sole durable owner of current weather phase:

```text
weather
weather_elapsed
weather_planned_duration
weather_transition_index
```

Weather definitions and transitions are authored content, not mutable runtime owners.

`WeatherProgressionService` advances `EnvironmentState`; it does not maintain a second hidden weather state.

---

# 2. Authored weather regimes

A weather regime supplies bounded environmental magnitudes and duration bounds.

Conceptually:

```text
WeatherDefinition
  id
  min_duration
  max_duration
  conditions
```

Example conditions:

```text
rain_intensity
wind_intensity
sun_intensity
```

The condition namespace is intentionally generic. Entity-specific effects do not belong in weather definitions.

---

# 3. Directed procedural transitions

Weather progression uses authored directed weighted transitions:

```text
WeatherTransitionDefinition
  from_weather
  to_weather
  weight
  optional event_type
```

Transition selection and planned duration are deterministic functions of durable causes:

```text
current authored weather id
+ persisted weather_transition_index
+ authored transition graph
→ next transition / duration
```

There is currently no caller-provided weather RNG seed. A separate run-entropy input must not be introduced until it becomes a common persisted causal boundary. Restore-equivalent durable causes therefore produce restore-equivalent future weather.

---

# 4. Coarse-step segmentation

A coarse simulation step may cross multiple weather regimes. Environmental effects must consume the exact elapsed time spent in each regime rather than applying the final regime retroactively over the whole step.

Example:

```text
2 second coarse step
= 1 second clear
+ 1 second rain
```

A rain response applies only to the one-second rain segment.

`WeatherProgressionService.advance(elapsed)` therefore returns ordered elapsed segments containing the condition snapshot active for each segment.

---

# 5. Environmental responses

Weather conditions do not mutate entities directly.

`EnvironmentalResponseDefinition` maps one condition magnitude to one bounded ordinary property mutation:

```text
condition
+ optional capability eligibility
+ optional susceptibility property
+ optional resolved exposure
+ semantic target selector
→ bounded property change
```

Supported target selectors currently include:

```text
self
assembly_slot(slot_id)
```

This permits configuration-relative effects such as:

```text
wind on a wet covering host
→ derived wind susceptibility
→ response targets configured binding slot
→ binding_integrity decreases
```

without testing weather names, shelter entity types, or component subclasses.

---

# 6. Protection and feedback

Environmental exposure is resolved independently through protection composition.

Canonical implemented feedback pressure:

```text
rain exposure
→ covering moisture
→ EffectivePhysicalProfile changes
→ wind susceptibility changes
→ wind response targets binding slot
→ binding integrity changes
→ transitive derived invalidation
→ host physical profile/protection can worsen
```

The environmental response service remains unaware of `shelter`, `roof`, `cloth`, or specific weather regime names.

---

# 7. Assembly/configuration boundary

Production runtime composition supplies `AssemblyBindingProjection` to effective physical profile derivation and environmental response targeting.

Assembly-slot derivations therefore work through the same composed runtime used by fresh runs and restored runs rather than only in specialized unit tests.

Relations/configuration remain authoritative World truth. Derived profiles and projections remain reconstructible.

---

# 8. Ambient weather events

A transition may author an ordinary semantic `WorldEvent`.

Ambient environmental events use:

```text
EventDefinition.access_scope = AMBIENT
```

They require no synthetic subject binding. Perception access may expose them through authored modalities and confidence.

An event may additionally declare:

```text
context_transition = true
```

This is domain semantics only. Application policy maps a perceived context transition to `ReconsiderationGate.Trigger.CONTEXT_TRANSITION`.

Weather progression itself never calls Wilson cognition.

---

# 9. Wilson behavioral continuity

A perceived ambient weather transition may influence Wilson only through the ordinary perceptual/cognitive chain:

```text
weather transition
→ semantic ambient WorldEvent
→ perception access
→ ObservedEvent
→ optional perceived context trigger / cue
→ ordinary candidate competition
→ CurrentIntention
```

Ambient observed events can activate `ObservedEventCueRule` without fabricating subject-specific `PerceptualEvidence`.

Regression-backed continuity:

```text
active partially progressed project
→ worsening weather perceived
→ context reconsideration
→ learned shelter habit wins competition
→ project owner remains active with progress intact
→ improving weather perceived
→ context reconsideration
→ shelter cue disappears
→ persistent project candidate wins again
→ same project resumes
```

Cognition does not read `EnvironmentState.weather` directly.

---

# 10. Persistence and restore equivalence

Snapshot schema persists weather phase causes:

```text
weather
weather_elapsed
weather_planned_duration
weather_transition_index
```

Fresh-run and restore paths both reconstruct environmental runtime through `RunRuntimeComposer`.

A restored simulation advanced by the same elapsed time must remain future-equivalent for:

```text
weather regime
weather elapsed/planned duration
transition index
environmental property mutations
emitted transition events
```

---

# 11. Content-pack surface

Content schema version 1 supports additive environmental fields:

```text
weather
weather_transitions
environmental_responses
protection_rules
dynamic_processes
```

Weather events may author:

```json
{
  "access_scope": "ambient",
  "context_transition": true
}
```

Environmental response target selection defaults to `self` and may explicitly target an assembly slot:

```json
{
  "target": {
    "kind": "assembly_slot",
    "slot": "roof_binding"
  }
}
```

Malformed selector shapes fail content loading instead of silently falling back to `self`.

---

# 12. Rejected alternatives

Do not introduce by default:

```text
WeatherSystem mutating entity types directly
ShelterWeatherSystem
storm_damage_shelter callbacks
weather-specific entity subclasses
Wilson cognition reading EnvironmentState.weather
synthetic ambient event subjects
final-weather retroactive application across a coarse tick
non-persisted caller weather RNG seed
```

---

# 13. Regression coverage

The implemented boundary is covered by dedicated regressions for:

```text
procedural progression
ambient event perception
coarse-step weather segmentation
environmental response mutation
protection/exposure composition
assembly-slot wind/binding stress
transitive effective-profile invalidation
fresh runtime composition
snapshot phase persistence
restore future equivalence
content-pack environmental authoring
context-triggered Wilson project continuity
```

Current local strict-suite checkpoint before the final content-loader/doc-only pass:

```text
RESULT: 118 PASS / 118 TOTAL
PASS headless_suite (118 tests)
```

A final strict run is required after any subsequent runtime/content-loader edit.