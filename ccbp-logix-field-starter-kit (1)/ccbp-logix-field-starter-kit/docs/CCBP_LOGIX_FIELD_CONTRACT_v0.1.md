# CCBP Logix Field Contract v0.1 (Rockwell / Studio 5000)

## 0) Scope and posture
This contract governs how control intent becomes Rockwell Logix artifacts (tags, UDTs, AOIs, routines, alarms, tests) in a way that is:
- inspectable (reviewable without running the machine),
- repeatable (same intent → same structure),
- field-compatible (works under commissioning pressure),
- portable (does not require PlantPAx, but remains compatible with it).

This is not a safety standard and does not replace OEM manuals, local electrical codes, or machine risk assessment.

## A) Provenance and change discipline (required)
Every project implementing this contract must include:
1) PROVENANCE header at top of each primary logic/document file:
- Project name
- Controller name(s)
- Contract version (CCBP_LOGIX_FIELD_CONTRACT_v0.1)
- Date
- Author(s)
- Change summary (one line)

2) Behavior change log (BEHAVIOR_CHANGELOG.md)
- Each entry states: what changed, why, and which acceptance test(s) cover it.

3) Traceability index (TRACEABILITY.md)
- Requirement/intent ID → affected tags/AOIs/routines → tests.

## B) Field naming standard (minimal + resilient)

### B1) Tag name style (required)
- Use ALL_CAPS with underscores for readability in the field.
- Avoid spaces, punctuation, and mixed casing.
- Keep device IDs stable across drawings, HMI, and PLC.

### B2) Device identity (required)
Each controlled thing gets a stable ID:
- Motors: MTR_###
- Valves: VLV_###
- Pumps: PMP_### (or treat as MTR_### + process context)
- Conveyors: CNV_###
- Analog loops: LIC_###, FIC_### if you have P&ID discipline; otherwise AI_###, AO_###

### B3) I/O tag prefixes (recommended, field-common)
- Discrete Inputs: DI_...
- Discrete Outputs: DO_...
- Analog Inputs: AI_...
- Analog Outputs: AO_...

Examples:
- DI_ESTOP_OK
- DI_MTR_101_OL_OK
- DO_MTR_101_RUN
- AI_TANK_101_LEVEL_PV

### B4) Program tags vs controller tags (required rule)
- Device instances and their command/status structs live at Program scope unless cross-program access is required.
- Shared plant-wide signals (E-stop OK, air pressure OK, mode request) may be Controller scope.

## C) Canonical data model (UDT set)

### C1) Command UDT (required)
UDT_CMD fields (BOOL unless noted):
- Start
- Stop
- Reset
- AutoReq
- ManReq
- MaintReq
- Inhibit
- Jog (optional)
- Spare[0..7] (optional)

### C2) Status UDT (required)
UDT_STS:
- Ready
- Running
- Faulted
- PermOK
- Interlocked
- CmdActive
- ModeAuto
- ModeMan
- ModeMaint
- Sim
- Heartbeat (optional)

### C3) Alarm UDT (required, field-simple)
UDT_ALM:
- Active
- Latched
- Acked
- Suppress (HMI/maintenance suppression; must be audited)
- Code (DINT)
- Severity (INT) — 1..100 (field-friendly)
- FirstOut (BOOL) (optional)

### C4) Device UDT (required pattern)
Each device UDT must include at least:
- Cmd : UDT_CMD
- Sts : UDT_STS
- Alm : UDT_ALM (or array if you prefer multi-alarm per device)
- Cfg struct (timers, debounce, permissive policy)
- IO struct (bound to DI/DO/AI/AO tags or aliases)

Example: UDT_MTR_2STATE

## D) AOI library (field minimum)

### D1) Required AOIs (or equivalent routines)
1) AOI_PERM_GATE
- Inputs: permissive bits (array or up to N)
- Output: PermOK
- Diagnostics: which permissive failed (bitmask DINT)

2) AOI_FAULT_LATCH
- Inputs: fault conditions (array or up to N)
- Inputs: Reset
- Output: FaultLatched
- Rules: fault latches immediately, reset clears only when reset allowed

3) AOI_MODE_ARB
- Inputs: requested modes
- Output: active mode bits
- Rule: deterministic priority: Maint > Man > Auto > Off

4) AOI_MTR_2STATE
- Handles: seal-in, permissives, trips, interlocks, output coil
- Must expose: PermOK, Faulted, Running, Ready, Interlocked
- Must implement: “start blocked if permissives false”
- Must implement: “stop always wins” (stop overrides start)

### D2) AOI interface discipline (required)
Each AOI must publish:
- Inputs (Cmd, permissives, trips, feedback, config)
- Outputs (to DO and to Sts/Alm)
- InOut for device struct when used
- Local diagnostics (bitmasks and timers), not leaking random internal state

## E) Core behavioral invariants (non-negotiable, field-safe)
1) Stop dominates Start
- If Stop=1 then RunCmd=0 regardless of Start state.

2) Permissives gate motion
- If PermOK=0 then RunCmd=0.
- If permissives drop while running: behavior must be explicit in config:
  - default: drop run + latch interlock/fault (recommended)

3) Faults latch
- Fault conditions latch Sts.Faulted=1.
- Reset clears only when:
  - Reset=1
  - fault conditions are no longer present
  - permissives are satisfied (default true)

4) Inhibit is auditable
- Cmd.Inhibit=1 forces outputs off.
- Inhibit must set Sts.Interlocked=1 and produce an alarm/event.

5) Simulation is explicit
- If sim is used, it must be controlled by Sts.Sim=1 and never “accidental”.
- Sim must not mask E-stop or true safety boundaries.

## F) Alarm and event conventions (field-ready)

### F1) Alarm philosophy
- Use simple alarms that technicians can interpret quickly.
- Alarm names should match drawings and HMI.

### F2) Minimum alarm set per device
For a motor:
- ESTOP_LOST (latched)
- OL_TRIP (latched)
- PERM_LOST (optional: active or latched, choose one)
- FB_MISMATCH (commanded run but no running feedback within timeout)

### F3) Severity mapping (field-friendly)
- 90–100: safety/emergency stop / critical trip
- 70–89: process-critical trip
- 40–69: warning that stops equipment
- 10–39: advisory / maintenance

### F4) Suppression rule (required)
If Alm.Suppress=1:
- alarm may be hidden from annunciation,
- but must remain traceable via a “suppressed alarms” list and require a reason code (HMI-side preferred).

## G) Routine structure (for humans at 2:00 AM)
Each Program should follow this rung order (or routine order):
1) I/O Conditioning
2) Mode Arbitration
3) Permissives + Interlocks
4) Device Control AOIs
5) Outputs Write
6) Alarms & Diagnostics
7) HMI/SCADA Interface

Rule: Outputs are written in one place per scan to avoid “who owns the coil?” chaos.

## H) Acceptance tests (field commissioning ready)

### H1) Test format (required)
ACCEPTANCE_TESTS.md with per-device tests containing:
- Preconditions
- Steps (set inputs / issue commands)
- Expected outputs and statuses
- Timing expectations (e.g., within 500 ms, within 2.0 s)

### H2) Minimum tests for any motion device
1) Start blocked when any permissive false
2) Stop overrides Start
3) Permissive drop stops device (and latches if configured)
4) Fault condition latches faulted status
5) Reset only clears when fault removed (and permissives OK if required)
6) Feedback mismatch alarms within configured timeout
7) Inhibit forces output off and raises diagnostic

## I) Field deployment constraints (stability under reality)
1) No hidden “magic bits”
- Every gating condition must appear in a permissive list or config.

2) No silent behavior changes
- Any behavior change requires:
  - changelog entry
  - updated acceptance test

3) Device library versioning
- AOIs/UDTs get explicit version fields (major/minor) and are logged in release notes.

## J) Deliverables checklist (what “done” means)
A project is “contract-complete” when it contains:
- TRACEABILITY.md
- BEHAVIOR_CHANGELOG.md
- ACCEPTANCE_TESTS.md
- AOI/UDT definitions (or documented equivalents)
- Tag naming compliance
- Routine structure compliance
- Minimum tests per device category

## K) Optional PlantPAx compatibility (no dependency)
If PlantPAx is present, you may map:
- device UDTs to PlantPAx faceplates conventions
- alarms to PlantPAx alarm objects

But: the contract remains valid without PlantPAx.
