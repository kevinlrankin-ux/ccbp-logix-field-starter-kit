# TAGGING_TEMPLATE.md
Rockwell Logix – Field Tagging & I/O Mapping Template

## 0) Purpose
Standardize how tags are named, grouped, and mapped so the field can troubleshoot quickly.

## 1) Global tag categories (required)

### 1.1 Controller-scope tags (shared)
Examples
- DI_ESTOP_OK
- DI_AIR_PRESS_OK
- MODE_PLANT_AUTO_REQ
- MODE_PLANT_MAINT_REQ

Rule
If a tag is not required by more than one Program, it does not belong at Controller scope.

### 1.2 Program-scope tags (default)
Each program owns device instances (UDTs), permissives, faults, intermediates.

## 2) Device instance tagging

### 2.1 Device instance tag
Format
<DEVICE_ID> : <UDT_TYPE>

Examples
MTR_101 : UDT_MTR_DOL
VFD_201 : UDT_VFD
VLV_301 : UDT_VLV_ONOFF
AI_401  : UDT_AI
PID_501 : UDT_PID_LOOP

### 2.2 Accessing fields
Examples
- MTR_101.Cmd.Start
- MTR_101.Sts.Running
- MTR_101.AlmSet.A1.Active
- AI_401.Val.PV_EU

## 3) I/O mapping pattern (field-safe)

### 3.1 Raw I/O tags
Discrete Inputs: DI_<DEVICE>_<SIGNAL>
Discrete Outputs: DO_<DEVICE>_<ACTION>
Analog Inputs: AI_<DEVICE>_<PV>
Analog Outputs: AO_<DEVICE>_<CV>

### 3.2 Mapping raw I/O into device UDTs
Mapping happens once, in an I/O conditioning routine.

Example – Motor
MTR_101.IO.DI_RunFb := DI_MTR_101_RUN_FB;
MTR_101.IO.DI_FaultFb := DI_MTR_101_OL_TRIP;
DO_MTR_101_RUN := MTR_101.IO.DO_RunCmd;

Rule
Raw I/O never appears directly inside control AOIs.

## 4) Permissive and fault tagging
Permissives: PERM_<DEVICE>_<CONDITION>
Faults: FLT_<DEVICE>_<CAUSE>

## 5) Alarm naming (HMI-friendly)
Format
<DEVICE>_<ALARM_NAME>

## 6) Anti-patterns (do not allow)
- Writing outputs in multiple routines
- Aliasing UDT internals directly to I/O
- TEMP1 / BIT_23 / MISC_OK tags
