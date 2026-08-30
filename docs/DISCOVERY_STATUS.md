# Product Discovery Status

## Current stage

The project is still in **functional/product discovery before architecture**.

Do not infer an implementation architecture, class hierarchy, data schema, ECS/component layout, storage ownership model, AI planner or final scoring algorithm directly from the current documents.

The behavioral discovery phase has now completed:

1. product fantasy and player role interviews;
2. interaction/property/knowledge discovery exploration;
3. psychology research and reduction;
4. independent 40-scene representative catalog;
5. scene triage;
6. detailed scene-pair/trio analysis;
7. 23 Must-have scene × system matrix;
8. 12-case regression suite designed to break the minimum model.

The regression suite did not justify additional broad psychological primitives.

---

## Document precedence

For current behavioral decisions, use this order:

1. **`BEHAVIORAL_MODEL.md`** — current validated functional Wilson model.
2. **`SCENE_VALIDATION.md`** — evidence, triage, matrices and regression tests behind that model.
3. **`AI.md`** — current runtime LLM authority/fallback contract.
4. **`PRODUCT.md`** — overall product fantasy, modes, interaction scope and presentation rules.
5. **`SIMULATION.md`** — broader simulation vocabulary and earlier behavioral notes.

Where an older provisional psychology paragraph in `PRODUCT.md` or `SIMULATION.md` conflicts with `BEHAVIORAL_MODEL.md`, the behavioral-model document wins.

In particular, older references to provisional `sociability`, `faith` as a standalone stat, `sanity`, or a generic caution/recklessness psychology model are superseded by the validated model.

---

## Current validated behavioral core

### Stable traits

```text
curiosity
risk_tolerance
independence
```

### Core drives

```text
hunger
energy
comfort
stimulation
```

### Persistent personal continuity

```text
beliefs / knowledge + confidence + scope
associations: valence + attachment
selected episodic history
habits
current/suspended intentions
projects
presence relationship: presence_belief + trust + dependency
```

### Derived / transient behavior

```text
attention / salience
expectations
candidate intention tendencies
causal interpretation weights
prediction error / anomaly strength
fear / anger / joy-excitement / reactions
```

### Explicitly rejected as independent primitives for now

```text
sanity
persistence
sociability
loneliness
playfulness
safety as an accumulating drive
cleanliness
orderliness
superstitiousness
faith separate from presence_belief
forgiveness
regret
routine
tradition
environmental ownership
global mood / persistent valence-arousal
```

These visible phenomena may still occur through combinations of the admitted concepts.

---

## Current player/presence relationship

```text
presence_belief [0,1]
trust           [-1,+1]
dependency      [0,1]
```

Interpretation of a particular anomaly additionally uses event-level causal attribution and attribution confidence.

Helpful and harmful interventions may both strengthen `presence_belief`; the direction of `trust` differs.

`independence` is a stable Wilson trait. `dependency` is learned reliance and can change quickly when intervention patterns change.

---

## Current LLM product contract

The game must be functionally complete without an LLM.

Runtime LLM roles are bounded to:

- sparse spoken/thought realization;
- reaction-language realization;
- diary/history prose realization;
- optional bounded reweighting of valid ambiguous interpretations;
- rare grounded embellishment among valid candidates.

The LLM does not own physical truth, action validity, death, project progress, authoritative memories or Wilson knowledge.

Initial interpretation calibration:

```text
~70% deterministic
~30% optional LLM-assisted
```

for **eligible ambiguous interpretation cases**, not all decisions/ticks.

Every LLM path has a deterministic same-function fallback.

---

## Current God Power conclusions

God Power remains one intervention currency in the primary mode.

Important qualitative rule:

> intervention cost should primarily reflect physical/causal magnitude and improbability, not Wilson's psychological attachment to the affected subject.

A tiny intervention such as moving a habitual spoon may create enormous narrative impact without needing an enormous cost.

The passive non-intervention streak supports the core rhythm:

```text
observe
→ accumulate intervention capacity
→ encounter meaningful moment
→ intervene or remain observer
→ live with consequences
```

Exact numbers remain uncalibrated.

---

## Current project conclusion

`Project` is a first-class functional concept because it carries persistent visible partial world progress across interruptions.

Projects:

- generate immediate intentions;
- compete with needs and other projects;
- can pause/resume;
- usually tend toward completion;
- may be functional, decorative or history-conditioned;
- do not require infinite procedural crafting.

Important content rule:

> systemic history may make an authored project/scene possibility contextually appropriate; the simulation does not need to invent the content form.

`Statue of Gerald` is the canonical example.

---

## Current knowledge conclusion

Keep distinct:

```text
world truth
Wilson belief/knowledge
Wilson expectation
player knowledge
```

Knowledge supports:

- basic/general principles;
- category expectations;
- type knowledge;
- instance knowledge;
- confidence;
- selected spatial/arrangement expectations;
- partial feedback and prediction-error updates.

Useful semantic interactions may consolidate from physical experimentation, but generic property-based action should remain capable of producing absurd valid solutions without pair-specific recipes.

---

## Current behavioral decision principle

Do not design Wilson around one objective rational utility.

Conceptually:

```text
possible
→ noticed
→ plausible
→ desired
→ competes
→ selected probabilistically among meaningful candidates
```

Suboptimal behavior should normally remain understandable from Wilson's subjective pressures, beliefs, history and emotion.

Traits modulate relevant contributions rather than acting like separate goals.

Immediate emergency is distinct from normal deliberation.

---

## Next design stage

The next recommended artifact is a **functional persistent-state inventory**, still before architecture.

For every admitted concept determine:

- whether it is authoritative or Wilson-relative;
- whether it is persisted or derived;
- lifetime: seconds / minutes / days / run / resurrection;
- scope: global Wilson / subject instance / type / category / place / project / episode;
- creation/update/removal conditions;
- offline behavior;
- consolidation/decay semantics;
- what content vocabulary is required;
- which representative scenes validate it.

After this inventory is stable, architecture/data-model work can begin with far less risk of encoding obsolete product assumptions.
