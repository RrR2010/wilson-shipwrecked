# AI / LLM Integration

## Purpose

LLMs add linguistic and creative variation without becoming the simulation authority.

The game must remain playable and internally consistent when the LLM is unavailable.

## Suitable responsibilities

### Natural-language intent parsing

Convert free player language into a constrained request:

```json
{
  "intent": "suggest_action",
  "action": "reuse_material",
  "target": "old_raft",
  "purpose": "shelter_project"
}
```

The simulation resolves IDs and determines feasibility.

### Dialogue realization

Turn structured facts, mood and selected memories into short Wilson dialogue. The LLM may choose wording but may not invent authoritative events/items.

### Summarization

Compress structured recent history into bounded narrative context for later dialogue. The structured history remains authoritative.

### Procedural-content proposal

Suggest supported event templates, parameters, combinations or flavor attributes. Proposals pass schema and domain validation before use.

### Development-time assistance

LLMs may generate Blender `bpy` code, Godot code, tests, data definitions, visual concepts and QA critiques under repository contracts.

## Forbidden authority

Runtime LLM output must not directly:

- create/delete arbitrary entities;
- change inventory/resources;
- modify needs/traits;
- mark goals complete;
- teleport actors;
- define arbitrary executable code/effects;
- bypass action preconditions;
- rewrite past authoritative state.

## Runtime contract

```text
Simulation
   |
   v
Context Builder -- only required facts --> LLM
                                      |
                                      v
                               structured response
                                      |
                                      v
                              schema validation
                                      |
                                      v
                              semantic validation
                                      |
                             accept / reject
```

Prefer JSON-schema/typed structured outputs where the provider supports them. Treat all generated strings/IDs as untrusted until resolved against allowed registries.

## Context design

Do not send full saves or full histories by default. Build task-specific context containing only:

- current request;
- relevant visible/known entities;
- relevant Wilson state;
- selected memories;
- allowed action/template vocabulary;
- tone/personality guidance when producing dialogue.

This reduces cost, latency and hallucination surface.

## Dialogue rules

Wilson dialogue should be concise enough for ambient presentation. Prefer one or two lines over monologues. Text should reflect known facts, current mood/personality and selected memories.

Do not use the LLM to make every routine action witty. Silence and animation are part of the experience.

## Model strategy

Keep providers/models behind an adapter. The domain must not import provider SDK concepts.

Potential request classes can have different model profiles:

```text
intent_parse       -> cheap/fast, thinking unnecessary
short_dialogue     -> cheap/fast
history_summary    -> cheap/fast
content_proposal   -> cheap/fast with strict validation
rare_complex_text  -> optional stronger model
```

The initial architecture should optimize for small models with thinking disabled where tasks are schema-constrained, while allowing model replacement without changing simulation code.

## Determinism and replay

LLM text itself need not be deterministic. However, if an accepted LLM proposal changes future simulation possibilities, persist the **validated resolved proposal** as authoritative input so a save/replay does not depend on regenerating the same answer.

## Failure behavior

- timeout: continue without generated content or use deterministic fallback;
- invalid JSON/schema: reject/fallback;
- unknown IDs: reject or resolve only through explicit mapping rules;
- impossible proposal: reject;
- dialogue hallucinating facts: discard/retry/fallback, never mutate state to make it true.

## Security

Do not place provider API keys in the web client or repository. A truly static public web build cannot safely hide a private LLM API key. Development may use local credentials; production AI features will require an appropriate protected proxy/backend or user-supplied credential strategy.

The core simulation must not require that service.

## Development-time Blender agents

For 3D generation, an LLM should act primarily as a **procedural asset engineer**:

1. read visual/asset contracts;
2. write/reuse `bpy` generators;
3. execute through Blender MCP/CLI;
4. run structural validation;
5. render canonical preview;
6. visually critique the actual output;
7. iterate a bounded number of times;
8. export/test GLB.

Do not judge a 3D asset solely from source code. A multimodal-capable reviewer should inspect rendered output whenever possible.
