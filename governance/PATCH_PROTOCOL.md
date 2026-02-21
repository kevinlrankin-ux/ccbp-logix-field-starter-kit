# Patch Protocol (CCBP)

## Scope
Applies to changes in:
- CONTRACT_INDEX.json
- governance/**
- 	ools/ccbp/**
- schema/policy definitions

## Rules
1) No silent breaking changes.
2) Any contract schema change must:
   - bump schema version (v1 -> v2)
   - preserve backward compatibility or provide a migration note
3) Tooling changes must be deterministic:
   - stable output formatting
   - explicit failure states (no fallbacks)
4) Gated actions:
   - PLC mutation remains forbidden unless explicitly enabled and separately reviewed.

## Evidence Requirements
Any patch must produce (or maintain ability to produce):
- rtifacts/BUILD_MANIFEST.json
- rtifacts/SAG_REPORT.md (can be stubbed initially)

## Review Checklist (Minimum)
- Does the patch reduce ambiguity?
- Does it preserve or improve safety boundaries?
- Does it keep overhead near-zero (one-command workflow)?
