## Siemens Field-Ready Commissioning Checklist (Conveyor Line)

### A. Pre-Power
- Verify I/O list matches drawings and tag dictionary
- Verify E-Stop loop continuity and safety chain behavior
- Verify jam switches and photoeyes are correctly wired and labeled
- Verify starter/VFD feedback input wiring and scaling (if applicable)

### B. Power-On / PLC Online
- CPU in RUN, no critical diagnostics
- OB1 scan time within acceptable bounds
- Blocks compiled without warnings/errors (SCL)

### C. I/O Checkout
- Inputs: simulate/actuate each sensor (JamOK, PE Entry/Exit, Running FB)
- Outputs: bump-test each zone run output with safe isolation
- Verify inhibit toggles (if used) stop only the intended zone

### D. Functional Tests
- E-Stop dominance (all zone run outputs forced OFF)
- Bounded reset (faults do not clear until safe conditions restored)
- Downstream-first start sequence
- Upstream-first stop behavior
- Alarm visibility and first-out banner correctness

### E. HMI/WinCC (NO_INST_DB)
- Confirm faceplates bind only to public status DBs
- Confirm alarm banner and per-zone alarm list correctness
- Confirm operator controls (Start/Stop/Reset, HOA, Local/Remote) behave as intended

### F. Handover
- FAT/SAT results signed
- As-built tag export saved
- Library version and change log recorded
