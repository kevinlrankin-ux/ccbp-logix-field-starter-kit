# AREA_A_EXAMPLE_WIRING_AND_TAGS.md
Area A — Example Wiring, Tag List, and Commissioning Checklist (Field Starter Kit v0.1)

## Complete tag list (Area A)

### Discrete Inputs (DI)
- DI_ESTOP_OK
- DI_AIR_PRESS_OK
- DI_GUARD_OK (optional)
- DI_MTR_101_OL_OK
- DI_MTR_101_RUN_FB
- DI_VFD_201_READY
- DI_VFD_201_RUN_FB
- DI_VFD_201_FAULT
- DI_VLV_301_OPEN_FB
- DI_VLV_301_CLOSE_FB

### Discrete Outputs (DO)
- DO_MTR_101_RUN
- DO_VFD_201_RUN
- DO_VLV_301_OPEN
- DO_VLV_301_CLOSE

### Analog Inputs (AI)
- AI_TANK_401_LEVEL_RAW

### Analog Outputs (AO)
- AO_VFD_201_SPEED_REF_HZ

## UDT instance tags (Program scope: 10_AREA_A)
- MTR_101 : UDT_MTR_DOL
- VFD_201 : UDT_VFD
- VLV_301 : UDT_VLV_ONOFF
- AI_401  : UDT_AI
- PID_501 : UDT_PID_LOOP

- MTR_101_PERM : UDT_PERM_SET16
- MTR_101_FLT  : UDT_FAULT_SET16
- VFD_201_PERM : UDT_PERM_SET16
- VFD_201_FLT  : UDT_FAULT_SET16
- VLV_301_PERM : UDT_PERM_SET16
- VLV_301_FLT  : UDT_FAULT_SET16

## Device pack bit assignment declarations (summary)
MTR_101
- Perm[0]=ESTOP_OK, Perm[1]=OL_OK, Perm[2]=AIR_OK, Perm[3]=GUARD_OK
- Fault[0]=ESTOP_LOST, Fault[1]=OL_TRIP, Fault[2]=FB_MISMATCH
- Alarm codes: 1101–1105

VFD_201
- Perm[0]=ESTOP_OK, Perm[1]=READY, Perm[2]=NO_FAULT
- Fault[0]=ESTOP_LOST, Fault[1]=DRIVE_FAULT, Fault[2]=FB_MISMATCH
- Alarm codes: 2101–2105

VLV_301
- Perm[0]=ESTOP_OK, Perm[1]=AIR_OK
- Fault[0]=ESTOP_LOST, Fault[1]=MOVE_TIMEOUT, Fault[2]=FB_CONFLICT, Fault[3]=CMD_CONFLICT
- Alarm codes: 3101–3104

AI_401
- Alarm codes: 4101–4104

PID_501
- Optional alarm codes: 5101–5103

## Commissioning sequence checklist (summary)
1) Validate raw I/O
2) Validate safety status inputs
3) Validate permissive masks and failed-mask bits
4) Validate fault latch/reset behavior
5) Functional device checkout (MTR/VFD/VLV)
6) Validate AI scaling + alarms
7) PID auto/manual/track checkout
8) Execute acceptance tests and log results
