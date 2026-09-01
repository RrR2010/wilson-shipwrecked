# Godot Engine Boundary

## Purpose

This document defines the first concrete boundary between the authoritative simulation and Godot's fine-grained 3D runtime.

The central rule is:

> Godot may provide spatial and physical facts; authoritative gameplay meaning remains in the simulation owners and application services.

## Runtime cadences

Rendering, physics integration, semantic simulation and cognition are distinct cadences.

Conceptually:

```text
render frames                 variable
physics progression           fine fixed cadence
semantic simulation           fixed/coarser cadence
cognition and learning        event/boundary driven
maintenance                   slower due cadence
```

A physics frame must not imply a broad cognition pass. Active movement may progress through many physics frames while Wilson keeps the same intention and action.

`SimulationCadenceClock` is the first engine-agnostic bridge: it accumulates fine-grained engine delta time and yields deterministic fixed-size semantic steps. Equal elapsed time must produce equal semantic-step counts regardless of frame partitioning.

## Spatial queries

`SpatialQueryPort` exposes semantic questions such as metric distance, route availability/cost, line of sight and interaction reachability.

A future Godot adapter may use `NavigationServer3D`, physics ray queries, explicit semantic anchors and a scene-instance registry to answer those questions. Application/domain callers must not depend directly on Godot nodes or server RIDs.

## Motion execution

`MotionPort` separates semantic movement requests from engine progression.

The simulation may request movement toward a stable semantic target. A Godot adapter may then run navigation steering, `CharacterBody3D` integration and collision response at physics cadence. It reports semantic motion states such as moving, arrived, blocked or route invalid.

Fine-grained position changes do not trigger cognition by themselves.

## Physical observations

`PhysicalObservationPort` carries engine-observed physical facts such as contacts, overlaps, grounding transitions or falls.

These observations are not authoritative gameplay consequences. A contact can feed a domain/application consequence resolver, which validates and commits any resulting World mutation before emitting semantic `WorldEvent`s.

```text
Godot contact/overlap
→ physical observation
→ consequence resolution
→ validated World mutation
→ WorldEvent
→ perception / learning / reconsideration as applicable
```

## Authority boundary

Forbidden coupling includes:

```text
Node3D name decides DomainId
collision callback directly mutates Wilson health
animation completion proves an action succeeded
navmesh route becomes persisted gameplay truth
presentation transform is fixture-authored authoritative state
```

Preferred integration is:

```text
authoritative/application request
→ typed engine-facing port
→ Godot adapter
→ semantic answer/observation
→ normal authoritative validation and mutation
```

## Testing

Headless tests may substitute deterministic fake adapters for spatial and motion ports. Godot integration tests should separately validate that real Navigation/Physics adapters honor the same semantics.

Scenario/bootstrap fixtures remain authored in durable semantic causes. Fine routes, collision caches, derived perception access and presentation transforms remain reconstructible.
