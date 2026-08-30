# AI / LLM Integration

## Purpose

Runtime LLM use is an **optional bounded variation layer** around a simulation that is already behaviorally complete.

The central contract is:

> The simulation decides what is true and what materially happens. The LLM may help interpret or express already-grounded truth where contextual variation has value.

The game must behave coherently when:

- no API key exists;
- the player disables AI features;
- the model/provider is unavailable;
- a request times out;
- a response fails validation.

There is no gameplay-critical degraded mode. Without the LLM, Wilson still decides, learns, reacts, remembers, develops habits/projects/relationships and the world continues normally. The only loss should be some contextual/narrative variety.

See `BEHAVIORAL_MODEL.md` for the validated Wilson model and `SCENE_VALIDATION.md` for the scene evidence behind the boundary described here.

---

## Runtime authority boundary

Runtime LLM output must **not** authoritatively decide or mutate:

- physical action validity;
- authoritative properties/capabilities;
- physical outcomes or transformations;
- injury/death outcomes;
- world truth;
- inventory/resources;
- needs/drives/traits;
- project progress/completion;
- God Power cost;
- offline catch-up truth;
- Wilson's authoritative knowledge;
- Wilson's authoritative memories;
- relationship values;
- impossible candidate actions;
- ordinary next goals with unrestricted authority;
- scene prerequisites;
- arbitrary executable effects/code.

The LLM cannot invent a fact and cause the simulation to become consistent with that invention.

---

## Validated runtime roles

### 1. Sparse Wilson speech/thought realization

The simulation determines the semantic intent and grounded context. The LLM may realize it as a very short line.

Example structured semantics:

```text
speech_act: accusatory_disbelief
target: unexplained_presence
reason: stored_materials_moved
tone: angry
verbosity: very_short
```

Possible LLM realization:

```text
"De novo?"
```

The exact line is flavor. The simulation already decided that Wilson suspects interference and is angry.

Wilson should remain relatively silent. Do not invoke a model for every routine action. Animation, pause, facial/body reaction, grunts, screams and silence are primary presentation channels.

A deterministic authored/template line bank must provide the same semantic function when no model is available.

### 2. Reaction realization

The simulation may supply a grounded reaction state such as:

```text
emotion: anger
subject: firepit_2
context: unexpectedly_worked_after_long_grudge
speech_act: resentful_disbelief
```

The LLM may choose a short textual realization. It does not choose the emotion, subject, learned belief or behavioral consequence.

### 3. Diary/history realization

The authoritative layer produces selected structured facts/episodes. The LLM may compress them into concise Wilson-voice diary prose.

Example input:

```text
actor: Gerald
action: steal
object: fish
wilson_hunger: high
expected: theft_attempt_likely
outcome: Gerald_succeeded
reaction: anger
importance: high
```

Possible output:

```text
"Gerald levou meu peixe de novo. Justo hoje."
```

The prose is representation, not memory authority.

Fallback: deterministic structured templates.

### 4. Bounded ambiguous interpretation

This is the highest-value reasoning use.

For an event with genuine ambiguity, the simulation first generates valid causal/interpretive candidates and baseline weights.

Example:

```text
EVENT:
spoon moved unexpectedly

VALID HYPOTHESES:
- self mistake
- animal
- unexplained ordinary cause
- unseen presence

CONTEXT:
- recent relevant anomalies
- presence belief
- trust
- selected memories
```

Normal deterministic path:

```text
simulation weights candidates
→ simulation samples/selects interpretation
```

Optional LLM-assisted path:

```text
simulation supplies bounded candidates + context
→ LLM proposes/reweights within limits
→ simulation validates/clamps
→ simulation performs final selection
```

The LLM cannot return `aliens`, an unknown actor or any explanation outside the allowed plausibility envelope.

The important design principle is:

> LLM assistance perturbs a bounded probability distribution using contextual information that would otherwise require many bespoke authoring rules.

### 5. Rare grounded scene embellishment

After the simulation/director has selected a valid scene or intention, the LLM may choose among supported grounded details:

- one short callback;
- one allowed gesture/reaction variant;
- one valid referenced object from a provided candidate set;
- concise scene-specific wording.

It may not invent new world facts, objects, memories, project forms or physical resolutions.

---

## Interpretation calibration

A useful initial product calibration is approximately:

```text
~70% deterministic interpretation
~30% optional LLM-assisted interpretation
```

This is **not** 30% of simulation ticks or actions.

It applies to **eligible ambiguous interpretation cases** where:

- multiple plausible candidates exist;
- history/context materially changes how Wilson might interpret them;
- different interpretations could create interesting future stories;
- the situation is not immediate safety-critical physical truth.

Suggested qualitative rates:

```text
simple everyday behavior           ~0–10%
ambiguous causal interpretation    ~30%
rare high-context interpretation   possibly higher
critical physical decision/truth   0%
offline simulation                 0%
```

These are calibration guides, not fixed implementation constants.

### Do not call merely because randomness is desired

Normal bounded stochastic choice is part of the deterministic simulation itself.

Use an LLM only when **contextual interpretation** adds enough value to justify latency/cost/failure surface.

Examples where LLM leverage is high:

- Missing Spoon;
- Someone Moved the Rock;
- Sabotaged Storage;
- an animal accidentally answering Wilson's Gift Test;
- a rich Gerald callback;
- choosing among several already-valid history-conditioned project interpretations.

Examples where it adds little or should not be used:

- palm actively falling;
- known physical action threshold;
- known hunger response;
- project stage completion;
- whether mushroom actually poisons Wilson;
- whether Wilson physically reaches a ledge.

---

## Failure and fallback contract

Every runtime LLM request must have a deterministic result with the **same semantic function**.

Examples:

| LLM use | Deterministic fallback |
|---|---|
| short Wilson line | authored/template line or silent gesture |
| diary prose | structured diary template |
| causal interpretation nudge | baseline weighted deterministic interpretation |
| reaction realization | authored reaction/animation variant |
| scene embellishment | ordinary authored/deterministic variant |

Functional rule:

```text
LLM request fails
→ immediately use deterministic fallback
→ simulation continues unchanged
```

Do not materially block Wilson or the simulation waiting for generated text.

Failure cases include:

- no configured model/API key;
- player-disabled AI;
- network/provider failure;
- timeout;
- invalid schema;
- unknown IDs;
- semantic validation failure;
- output referring to unsupported facts.

---

## Context design

Never send an unrestricted full save/history by default.

Build a task-specific context containing only what can legitimately influence that request:

- current semantic task;
- relevant visible/known entities;
- current Wilson state required for interpretation;
- selected relevant memories/episodes;
- allowed candidate hypotheses/actions/templates;
- presence relationship values where relevant;
- tone/personality guidance for language realization;
- explicit forbidden invention constraints.

Benefits:

- lower cost;
- lower latency;
- easier grounding;
- reduced hallucination surface;
- simpler validation;
- less accidental disclosure of irrelevant state.

---

## Memory and LLMs

Structured simulation state is authoritative.

The LLM may:

- summarize selected episodes for prose;
- choose wording that references memories explicitly supplied in context;
- help rank valid interpretation candidates using supplied history.

The LLM may **not**:

- create an authoritative memory because it wrote a good line;
- invent a callback that did not happen;
- decide what Wilson consciously remembers;
- alter memory importance/association values directly;
- rewrite or reconcile simulation history.

Example safe callback:

```text
CURRENT:
materials scattered

SUPPLIED PRIOR:
spoon moved mysteriously yesterday

speech intent:
recognition_of_repeat_anomaly
```

LLM may say:

```text
"De novo?"
```

It may not reference an unsupplied red hat incident.

---

## Beliefs, superstition and causal attribution

The LLM may help choose/reweight only among causal beliefs already permitted by the simulation.

A superstition remains an authoritative **Wilson belief**, not an LLM truth claim.

Example:

```text
actual cause:
Gerald took offering unseen

allowed Wilson hypotheses:
- animal
- unseen presence
- unknown
```

The LLM may contextually nudge the unseen-presence hypothesis when Wilson has strong presence belief and deliberately staged the test. The simulation still chooses the final hypothesis and stores any resulting belief.

No LLM-authored world rule such as `blue shells cause rain` becomes valid unless the simulation independently represents that as a permitted mistaken Wilson belief based on observed evidence.

---

## Projects and LLMs

Runtime LLMs do not invent project geometry, recipes or arbitrary new projects.

A useful bounded role is choosing among **already authored, currently valid** contextual project possibilities.

Example:

```text
VALID PROJECT CANDIDATES:
- improve table
- decorate shelter
- crude Gerald effigy
```

Long Gerald history may make the third narratively appropriate. An optional LLM may nudge its weight, but cannot invent `build cathedral to Gerald`.

This supports a core content principle:

> systemic history can select authored content because the run made it appropriate; the model does not need to invent the content itself.

---

## Player-language intent parsing

If free player language is supported, an LLM may translate it into a **constrained request**.

Example:

```json
{
  "intent": "suggest_action",
  "action": "reuse_material",
  "target": "old_raft",
  "purpose": "shelter_project"
}
```

The simulation resolves IDs, checks Wilson knowledge/mode constraints, determines feasibility and treats the result as a suggestion rather than a command.

Fallback should include supported UI/contextual suggestions so core play never requires natural-language parsing.

---

## Validation

Prefer typed/schema-constrained model outputs where supported.

Validation occurs in layers:

```text
Simulation
   ↓
Task-specific Context Builder
   ↓
LLM
   ↓
Schema validation
   ↓
ID/candidate resolution
   ↓
Semantic/domain validation
   ↓
Clamp / accept / reject
   ↓
Simulation remains final authority
```

Generated strings and identifiers are untrusted until resolved against provided registries/candidate sets.

---

## Determinism, saves and replay

Generated prose itself does not need deterministic regeneration.

If an accepted bounded LLM proposal influences a future authoritative interpretation, persist the **resolved simulation result**, not a dependency on regenerating the same answer.

Example:

```text
LLM nudges causal candidates
→ simulation resolves presence attribution with confidence X
→ resolved attribution/belief update is persisted normally
```

Replay/save correctness must never depend on a provider returning identical text or weights later.

---

## Model/provider strategy

Keep provider/model concepts behind an adapter boundary when architecture work begins.

MiMo V2.5 is an available candidate resource, but behavioral design must remain model-independent.

Different request classes can use different model profiles:

```text
intent_parse          cheap/fast/schema constrained
short_dialogue        cheap/fast
history_realization   cheap/fast
bounded_interpretation fast + structured
rare_complex_text     optional stronger profile
```

Avoid spending stronger-model latency on routine text or decisions the simulation already handles well.

---

## Security

Do not place provider API keys in a public web client or repository.

A static public web build cannot safely hide a private provider credential. Production AI features require an appropriate protected proxy/backend or an explicitly supported user-supplied credential strategy.

No credential should be required for the core game.

---

## Development-time AI assistance

Development-time LLM/agent use is separate from runtime Wilson cognition.

Suitable tasks include:

- Godot code and tests;
- data/content definitions;
- simulation QA analysis;
- balance analysis;
- Blender `bpy` asset generators;
- visual concepts and critiques;
- documentation maintenance.

### Development-time Blender agents

For procedural 3D generation, an LLM should act primarily as a procedural asset engineer:

1. read visual/asset contracts;
2. write/reuse `bpy` generators;
3. execute through Blender MCP/CLI;
4. run structural validation;
5. render canonical preview;
6. visually critique the actual output;
7. iterate a bounded number of times;
8. export/test GLB.

Do not judge a 3D asset solely from source code. A multimodal reviewer should inspect rendered output whenever practical.
