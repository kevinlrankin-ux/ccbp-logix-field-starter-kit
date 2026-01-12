# STARTER_PROJECT_STRUCTURE.md
Studio 5000 (Logix) — Field Starter Project Structure v0.1

## 0) Purpose
Define a repeatable controller layout that prevents output ownership conflicts and speeds commissioning.

## 1) Programs (recommended)
00_INFRA
01_IO
02_MODE
03_SAFETY_IF
10_AREA_A
20_AREA_B
90_HMI_SCADA
99_UTIL

## 2) Tasks (field default)
MAIN_TASK: Periodic 100 ms (typical)
Optional FAST_TASK: Periodic 10–20 ms (only when justified)

## 3) Routine prefix meanings
R00_ infra
R10_ I/O conditioning
R20_ mode/permissives/faults
R30_ device AOIs
R40_ outputs write
R50_ alarms/diagnostics
R90_ HMI interface
R99_ utilities/sim

## 4) Program: 10_AREA_A routine order (exact)
R10_AREA_TAG_INIT
R20_AREA_PERMISSIVES
R20_AREA_FAULTS
R30_AREA_DEVICE_CONTROL
R40_AREA_OUTPUTS_WRITE
R50_AREA_ALARMS_SUMMARY
R90_AREA_HMI_INTERFACE

## 5) Scan ownership rules (non-negotiable)
- DO_/AO_ written in exactly one routine per area (R40_AREA_OUTPUTS_WRITE)
- Device Cmd.* written only in HMI interface routine
- Device Sts.* written only by AOIs
- Permissives only in R20_AREA_PERMISSIVES
- Fault latches only in R20_AREA_FAULTS
