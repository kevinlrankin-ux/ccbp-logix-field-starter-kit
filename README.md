# CCBP Rockwell Conveyor Line (5-Zone)

This repository provides a **field-ready** Rockwell Logix / Studio 5000 control architecture for a multi-zone conveyor line, governed by the **Consciousness–Capability Boundary Project (CCBP)**.

## What This Is
- A **spec-first** industrial automation template
- Target platform: **Rockwell Logix** (CompactLogix / ControlLogix), **Studio 5000**
- Implementation: AOI-based section modules + deterministic sequencing
- HMI policy: **NO_AOI_INTERNALS** (HMI reads **public status tags only**)

## What This Is Not
- Not a safety-certified (GuardLogix / SIL) implementation
- Not a replacement for commissioning, validation, or site safety requirements

## Repository Contents
- `spec/` — Authoritative CCBP control specification (YAML)
- `plc/` — Tag plan, AOI contracts, L5X placeholders, routine maps
- `hmi/` — FactoryTalk faceplate binding contract (NO_AOI_INTERNALS)
- `alarms/` — Alarm catalog (YAML)
- `tests/` — FAT/SAT tests (YAML)
- `docs/` — Commissioning checklist + architecture notes

## Quick Start
1. Review `spec/conveyor_line_5zone.yaml`
2. Create tags per `plc/tag_plan/TAG_PLAN.md`
3. Implement AOIs per `plc/aoi_contracts/`
4. Implement sequencing routine per `plc/routines/MainRoutine_Sequencer.md`
5. Bind HMI per `hmi/faceplates.md`
6. Execute FAT/SAT tests in `tests/fat_sat_tests.yaml`

## License
Apache-2.0. See `LICENSE`.

---

## ChatGPT Runtime Prompt (CCBP-Aligned)

The following prompt can be used to operate ChatGPT as a **CCBP-aligned analytical runtime**
for reasoning about, extending, or validating this Logix Field Starter Kit.

### Usage
- Paste this prompt into ChatGPT
- Then provide specs, questions, or change requests
- The model will respond **without anthropomorphic framing** and without claiming agency

### Runtime Prompt


### Intended Uses
- Reviewing or extending `spec/conveyor_line_5zone.yaml`
- Designing AOI internals that satisfy published contracts
- Stress-testing sequencing and alarm precedence logic
- Generating FAT/SAT scenarios consistent with CCBP constraints

This prompt is optional and non-binding. Human engineering judgment remains authoritative.
