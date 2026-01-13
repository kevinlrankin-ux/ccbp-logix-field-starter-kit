# CCBP Logix Field Starter Kit (Rockwell / Studio 5000)

This repository is a **field-ready starter kit** for Rockwell Logix projects using a CCBP-governed specification approach.

It includes: 
- Governance contract (CCBP Logix Field Contract)
- Field library spec (UDTs + AOI I/O signatures)
- Tagging and I/O mapping templates
- Acceptance test templates
- Starter Studio 5000 project structure
- Device pack examples (MTR/VFD/VLV/AI/PID)
- Area A full tag list + commissioning sequence checklist

## Folder layout
- `docs/` — canonical documents and templates

## How to use (suggested)
1. Start a new Logix project using `docs/STARTER_PROJECT_STRUCTURE.md`
2. Apply naming and I/O conventions in `docs/TAGGING_TEMPLATE.md`
3. Instantiate devices using `docs/DEVICE_PACK_EXAMPLES.md`
4. Commission using `docs/AREA_A_EXAMPLE_WIRING_AND_TAGS.md` + `docs/ACCEPTANCE_TESTS_TEMPLATE.md`
5. Track behavioral changes in `docs/BEHAVIOR_CHANGELOG.md` and traceability in `docs/TRACEABILITY.md`

Field Adoption

This starter kit is intended to be adopted as a documentation-first control standard alongside normal Rockwell Logix (Studio 5000) workflows. Begin by using the provided project structure, tagging conventions, and device packs as the baseline for a new or retrofit PLC project. Instantiate devices using the defined UDT/AOI patterns, calculate permissives and fault latches explicitly, and execute commissioning using the included acceptance test templates. This kit does not replace engineering judgment, safety systems, or vendor tools; instead, it provides a consistent, inspectable framework that improves clarity, repeatability, and handoff quality across design, commissioning, operations, and maintenance.

## Version
- Contract: `CCBP_LOGIX_FIELD_CONTRACT_v0.1`
- Library: `LOGIX_FIELD_LIBRARY_SPEC_v0.1`
