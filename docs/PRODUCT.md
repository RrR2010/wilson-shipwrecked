# Product & Game Design

## Elevator pitch

**Wilson Shipwrecked** is a fullscreen living diorama about sharing a persistent castaway world with an autonomous character. Wilson acts on his own, the player can interfere when opportunities exist, and both gradually reshape the island and Wilson's future.

The desired feeling is closer to **coexistence** than control.

## Experience pillars

### 1. Something is always happening

Opening the game should rarely show a character waiting for commands. Wilson may be working, resting, investigating, failing, improvising or reacting to something that happened while the player was away.

### 2. Watching is valid play

The world must be legible and entertaining without constant clicking. Animation, environmental change, small comedy and surprising behavior carry the ambient experience.

### 3. Interaction is opportunistic and contextual

The player can initiate interaction, not only answer prompts. Selecting an entity exposes affordances valid *now*: inspect, move, give, suggest, use, help, disturb, collect, etc. Available choices change with tools, knowledge, relationships and world state.

### 4. Wilson is an actor, not an avatar

Player suggestions are inputs to Wilson's decision process. Trust, independence, mood, urgency and feasibility can make him accept, refuse, postpone or reinterpret advice.

### 5. History becomes scenery

Progress should be visible: paths emerge, shelters expand, stored objects accumulate, vegetation changes, projects remain half-built, found objects become decorations, and past decisions leave scars or conveniences.

### 6. Stories emerge from systems

Prefer `storm + weak shelter + scarce wood + unfinished raft` over a handcrafted `storm chapter`. Bespoke authored events are seasoning, not the main content engine.

## Player verbs

The exact list will evolve, but interaction should derive from a compact vocabulary such as:

- inspect / ask about;
- suggest / discourage;
- give / take / place;
- collect / harvest;
- open / close;
- move / carry;
- use / combine;
- build / repair / dismantle;
- help / interrupt;
- talk.

Not every verb is direct player control. `Suggest cutting tree` may ask Wilson to perform an action rather than making the tree instantly disappear.

## Wilson model

Wilson should have at least four classes of internal state:

### Needs
Short/medium-term pressures: hunger, energy, safety, social/companionship, comfort, curiosity.

### Traits
Slow-changing personality axes such as curiosity, risk tolerance, optimism, sociability, independence and trust toward the player.

### Knowledge
Facts Wilson has learned. The simulation may know something that Wilson does not.

### Memories
Durable events with subject, valence, importance and time. Memories can affect decisions and provide compact context for dialogue.

## Progression

Avoid a conventional level tree. Progression is primarily **capability-space expansion**:

```text
find rope
  -> binding becomes available
  -> new constructions become feasible
  -> new goals can be planned
  -> new locations become reachable
  -> new event templates become eligible
```

Progress can also close possibilities. Cutting the last mature palm may solve today's shelter problem while removing a future food source.

## Procedural content layers

1. **World generation:** seed → terrain/biomes → placements → visual variants.
2. **Systemic interactions:** properties + verbs + state generate legal actions.
3. **Autonomous behavior:** needs/traits → utility → goals → plans.
4. **Event director:** constrained external events introduce novelty.
5. **Narrative grammar:** compatible events can form setup/complication/resolution arcs.
6. **LLM variation:** dialogue and validated content proposals provide surface diversity.

## Humor

Humor should primarily come from timing, animation, Wilson's reactions and systemic mismatch—not constant jokes in text. The tone can be dry, playful and occasionally absurd while preserving internal world rules.

## UI philosophy

Default presentation is the world itself. Persistent HUD should be minimal or absent.

- Hover/click/tap may reveal contextual controls.
- Selecting an object reveals only current affordances.
- Wilson may use speech/thought bubbles sparingly.
- Menus should retreat when not used.
- Debug information belongs to a developer overlay, not the normal experience.

## Failure and survival

Do not assume traditional permadeath. Early prototypes should favor interesting consequences over hard game-over states. Severe failures may create recovery arcs, scars, lost resources or changed behavior.

## Content quality rule

Before adding a bespoke object, event or animation, ask:

> Can this be expressed by extending a reusable property, action, component, template or visual primitive?

If yes, prefer the reusable primitive.

## Vertical-slice acceptance criteria

A successful first slice demonstrates:

- autonomous behavior for at least 15–30 minutes without player input;
- multiple legal player-initiated contextual interactions;
- one decision with a delayed consequence;
- one multi-action autonomous plan;
- one environmental event that changes priorities;
- visible environmental progression;
- save/load and elapsed-time catch-up;
- enough randomized variation that two seeds/runs do not immediately tell the same sequence;
- coherent visual style across independently produced assets.
