# Envelope State Contract
(Operationality, Labeling, Stamping, Promotion)

This document defines the minimal envelope lifecycle used by this repo.
It is intentionally light-weight to enable near-zero overhead flow while preventing drift and mimicry.

---

## Definitions

### Abstract (Read-only)
An envelope is **Abstract** if it is missing required CCBP invariants or does not meet the required internal structure.
- Not eligible for OH-01 labeling.
- Not eligible for stamping.
- Not eligible for promotion.

### Operational (CCBP-complete)
An envelope is **Operational** if it contains, in required structure:
- Book I invariants
- Book II invariants
- Appendix A invariants
- Payload artifacts (kernel/constitution/README/ladder/etc.) arranged to prevent drift ("locking mirrors" posture)

Operationality is a **CCBP property** (semantic and structural completeness).

### Labeled (OH-01 passed)
An envelope is **Labeled** when it passes the ASP validation step **OH-01 ("Label")**.
OH-01 confirms structural legitimacy (anti-mimicry / structural correctness) and emits:
- a canonical structural hash (SHA-256)
- a label artifact recording validation results

Labeling is a **fast structural attestation**, not an execution authorization.

### Stamped (Human authorization; sealed)
An envelope is **Stamped** when a human issues a stamp of approval.
Stamping:
- expresses explicit human authorization
- seals the envelope contents at a known hash
- is required before promotion

Stamping is the **authorization event**.

### Promoted (Approved path)
An envelope is **Promoted** when the repo moves artifacts into the approved operational path
(e.g., plc/approved, deployment bundles, etc.), but only if:
- envelope is Operational
- envelope is Labeled (OH-01)
- envelope is Stamped (human authorization)

---

## Minimal State Machine

Abstract → Operational → Labeled → Stamped → Promoted

Hard rule:
- No skipping states.

---

## Required Artifacts (minimum)

For a change request changes/CR-XXXX/:

- envelope.yaml (declares invariants and pointers)
- draft output(s) (e.g., draft_ladder_candidate.txt)
- label_oh-01.json (emitted by OH-01 validation)
- stamp.yaml (human authorization; seals to label hash)

---

## Intent

- CCBP makes the envelope operational (meaning + invariants + drift resistance).
- OH-01 label makes it structurally admissible (anti-mimicry; low overhead validation).
- Stamp makes it authorized (human approval; sealed).
- Promotion moves it into approved execution pathways.

