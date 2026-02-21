# CCBP Kernel (Repo Constitution)

## Identity
- Repo: ccbp-logix-field-starter-kit
- Platform: logix
- Profile: conveyor_line

## Non-negotiables (Boundaries)
1) Contract-first: CONTRACT_INDEX.json is the single root pointer map for automation.
2) No hidden internals to HMI:
   - Policy: NO_AOI_INTERNALS
   - Rule: HMI binds only to PUBLIC_STATUS surfaces (never internal step state).
3) Deterministic sequencing:
   - State machines must be explicit and reviewable.
   - No time-based hidden transitions without declared conditions.
4) No mutation by default:
   - Tooling writes only under rtifacts/ and dist/ unless a gate explicitly permits mutation.
5) Evidence over narrative:
   - Outputs must include status + evidence + next_action. No guessing.

## Definitions (Minimal)
- “Contract Index”: The file that declares authoritative inputs, required outputs, and gates.
- “Public Status”: The set of exposed tags/DB fields intended for HMI/SCADA consumption.
- “Deterministic Sequencing”: State transitions are condition-driven, declared, and testable.

## Change Control
All constitutional changes follow the Patch Protocol.
