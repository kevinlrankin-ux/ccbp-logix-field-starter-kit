# Logix Field Library Spec v0.1 (UDTs + AOI Signatures)

## 1) Global conventions (field-ready)
Datatypes
- BOOL for discrete, DINT for bitmasks/codes, REAL for PV/SP/CV, INT for severity.
- All timers are REAL seconds in config; AOI implements with TON.

Bitmask rule
- Any “why not ready” / “which permissive failed” returns a DINT mask:
  - Bit 0 = first condition, Bit 1 = second, etc.

Mode priority (deterministic)
- MAINT > MAN > AUTO > OFF

## 2) Common UDTs

### 2.1 UDT_CMD (Commands)
- Start (BOOL)
- Stop (BOOL)
- Reset (BOOL)
- AutoReq (BOOL)
- ManReq (BOOL)
- MaintReq (BOOL)
- Inhibit (BOOL)
- JogFwd (BOOL) (optional)
- JogRev (BOOL) (optional)
- Spare[0..7] (BOOL array) (optional)

### 2.2 UDT_STS (Status)
- Ready (BOOL)
- Running (BOOL)
- Faulted (BOOL)
- PermOK (BOOL)
- Interlocked (BOOL)
- CmdActive (BOOL)
- ModeAuto (BOOL)
- ModeMan (BOOL)
- ModeMaint (BOOL)
- Sim (BOOL)
- Heartbeat (BOOL) (optional)
- WhyNotReadyMask (DINT)

### 2.3 UDT_ALM (Single alarm instance)
- Active (BOOL)
- Latched (BOOL)
- Acked (BOOL)
- Suppress (BOOL)
- Code (DINT)
- Severity (INT) (1..100)
- FirstOut (BOOL) (optional)

### 2.4 UDT_ALM_SET8 (common field grouping)
- A0..A7 (UDT_ALM) (8 alarms)
- SummaryActive (BOOL)
- SummaryLatched (BOOL)
- SummaryHighestSeverity (INT)
- FirstOutCode (DINT)

### 2.5 UDT_PERM_SET16
- Perm[0..15] (BOOL)
- PermOK (BOOL)
- FailedMask (DINT)

### 2.6 UDT_FAULT_SET16
- Fault[0..15] (BOOL)
- Latched (BOOL)
- ActiveMask (DINT)
- FirstOutMask (DINT)

### 2.7 UDT_MODE
- Off (BOOL)
- Auto (BOOL)
- Man (BOOL)
- Maint (BOOL)
- ModeCode (DINT) (0=Off,1=Auto,2=Man,3=Maint)

## 3) Device UDTs (field minimum)

### 3.1 UDT_MTR_DOL (Motor starter / DOL)
Struct
- Cmd : UDT_CMD
- Sts : UDT_STS
- AlmSet : UDT_ALM_SET8
- Cfg:
  - FB_RunRequired (BOOL)
  - FB_RunTimeout_s (REAL)
  - PermDropStops (BOOL)
  - PermDropLatchesFault (BOOL)
  - ResetRequiresPermOK (BOOL)
  - DebounceFb_ms (DINT) (optional)
- IO:
  - DI_RunFb (BOOL)
  - DI_FaultFb (BOOL) (optional)
  - DO_RunCmd (BOOL)

### 3.2 UDT_VFD (VFD run + speed reference)
- Cmd : UDT_CMD
- Sts : UDT_STS
- AlmSet : UDT_ALM_SET8
- Cfg:
  - FB_RunTimeout_s (REAL)
  - PermDropStops (BOOL)
  - PermDropLatchesFault (BOOL)
  - ResetRequiresPermOK (BOOL)
  - MinHz (REAL)
  - MaxHz (REAL)
  - DefaultHz_Man (REAL)
  - SpeedFollowsAutoSP (BOOL)
- IO:
  - DI_RunFb (BOOL)
  - DI_FaultFb (BOOL)
  - DI_ReadyFb (BOOL) (optional)
  - DO_RunCmd (BOOL)
  - AO_SpeedRef_Hz (REAL)

### 3.3 UDT_VLV_ONOFF (Valve open/close discrete)
- Cmd : UDT_CMD (Start=Open, Stop=Close, Reset=Clear faults)
- Sts : UDT_STS
- AlmSet : UDT_ALM_SET8
- Cfg:
  - HasOpenFb (BOOL)
  - HasCloseFb (BOOL)
  - MoveTimeout_s (REAL)
  - PermDropStops (BOOL)
  - ResetRequiresPermOK (BOOL)
- IO:
  - DI_OpenFb (BOOL)
  - DI_CloseFb (BOOL)
  - DI_FaultFb (BOOL) (optional)
  - DO_OpenCmd (BOOL)
  - DO_CloseCmd (BOOL)

### 3.4 UDT_AI (Analog input channel)
- Cmd : UDT_CMD
- Sts : UDT_STS
- AlmSet : UDT_ALM_SET8
- Cfg:
  - EU_Min (REAL)
  - EU_Max (REAL)
  - Raw_Min (REAL) (optional)
  - Raw_Max (REAL) (optional)
  - Filter_TC_s (REAL)
  - HiHi (REAL)
  - Hi (REAL)
  - Lo (REAL)
  - LoLo (REAL)
  - Deadband (REAL)
  - AlarmLatching (BOOL)
- Val:
  - PV_EU (REAL)
  - PV_Filt_EU (REAL)
  - BadQuality (BOOL)

### 3.5 UDT_AO (Analog output channel)
- Cmd : UDT_CMD
- Sts : UDT_STS
- AlmSet : UDT_ALM_SET8
- Cfg:
  - EU_Min (REAL)
  - EU_Max (REAL)
  - FailSafe_EU (REAL)
  - ClampMin_EU (REAL)
  - ClampMax_EU (REAL)
- Val:
  - CV_EU (REAL)
  - CV_Out_EU (REAL)

### 3.6 UDT_PID_LOOP (basic field PID)
- Cmd : UDT_CMD
- Sts : UDT_STS
- AlmSet : UDT_ALM_SET8
- Cfg:
  - Kp (REAL)
  - Ti_s (REAL)
  - Td_s (REAL)
  - CV_Min (REAL)
  - CV_Max (REAL)
  - TrackEnabled (BOOL)
  - TrackValue (REAL)
  - PV_BadHoldsOutput (BOOL)
- Val:
  - PV (REAL)
  - SP (REAL)
  - CV (REAL)
  - CV_Man (REAL)

## 4) AOIs (I/O signatures)

### 4.1 AOI_MODE_ARB
Inputs
- AutoReq (BOOL), ManReq (BOOL), MaintReq (BOOL)
- ForceOff (BOOL) (optional)
Outputs
- Mode : UDT_MODE
- ModeMask (DINT)

### 4.2 AOI_PERM_GATE16
Inputs
- Perm[0..15] (BOOL array)
- Inhibit (BOOL)
Outputs
- PermOK (BOOL)
- FailedMask (DINT)

### 4.3 AOI_FAULT_LATCH16
Inputs
- Fault[0..15] (BOOL array)
- Reset (BOOL)
- ResetAllowed (BOOL)
Outputs
- Latched (BOOL)
- ActiveMask (DINT)
- FirstOutMask (DINT)

### 4.4 AOI_ALM_EVAL
Inputs
- Condition (BOOL)
- Reset (BOOL)
- Ack (BOOL)
- Suppress (BOOL)
- Latching (BOOL)
- Code (DINT)
- Severity (INT)
InOut
- Alm : UDT_ALM
Outputs
- SummaryActive (BOOL)
- SummaryLatched (BOOL)

### 4.5 AOI_MTR_DOL
Inputs
- Cmd : UDT_CMD
- Mode : UDT_MODE
- PermOK (BOOL)
- PermFailedMask (DINT)
- TripLatched (BOOL)
- RunFb (BOOL)
- FaultFb (BOOL) (optional)
- Sim (BOOL)
- Cfg_FB_RunRequired (BOOL)
- Cfg_FB_RunTimeout_s (REAL)
- Cfg_PermDropStops (BOOL)
- Cfg_PermDropLatchesFault (BOOL)
Outputs
- DO_RunCmd (BOOL)
- Sts : UDT_STS
- WhyNotReadyMask (DINT)
- FbMismatch (BOOL)

### 4.6 AOI_VFD_RUNSPD
Inputs
- Cmd : UDT_CMD
- Mode : UDT_MODE
- PermOK (BOOL)
- TripLatched (BOOL)
- RunFb (BOOL)
- FaultFb (BOOL)
- ReadyFb (BOOL) (optional)
- AutoSpeedSP_Hz (REAL)
- ManSpeed_Hz (REAL)
- Sim (BOOL)
- Cfg_MinHz (REAL)
- Cfg_MaxHz (REAL)
- Cfg_FB_RunTimeout_s (REAL)
- Cfg_SpeedFollowsAutoSP (BOOL)
Outputs
- DO_RunCmd (BOOL)
- AO_SpeedRef_Hz (REAL)
- Sts : UDT_STS
- FbMismatch (BOOL)

### 4.7 AOI_VLV_ONOFF
Inputs
- Cmd : UDT_CMD (Start=open, Stop=close)
- Mode : UDT_MODE
- PermOK (BOOL)
- TripLatched (BOOL)
- OpenFb (BOOL)
- CloseFb (BOOL)
- FaultFb (BOOL) (optional)
- Sim (BOOL)
- Cfg_HasOpenFb (BOOL)
- Cfg_HasCloseFb (BOOL)
- Cfg_MoveTimeout_s (REAL)
Outputs
- DO_OpenCmd (BOOL)
- DO_CloseCmd (BOOL)
- Sts : UDT_STS
- MoveTimeout (BOOL)
- FbMismatch (BOOL)

### 4.8 AOI_AI_SCALE_ALM
Inputs
- Raw (REAL)
- Cmd : UDT_CMD
- Cfg_EU_Min (REAL), Cfg_EU_Max (REAL)
- Cfg_Filter_TC_s (REAL)
- Cfg_HiHi (REAL), Cfg_Hi (REAL), Cfg_Lo (REAL), Cfg_LoLo (REAL)
- Cfg_Deadband (REAL)
- Cfg_AlarmLatching (BOOL)
- Sim (BOOL)
Outputs
- PV_EU (REAL)
- PV_Filt_EU (REAL)
- BadQuality (BOOL)
- AlmSet : UDT_ALM_SET8

### 4.9 AOI_AO_CLAMP
Inputs
- Cmd : UDT_CMD
- Mode : UDT_MODE
- CV_In_EU (REAL)
- Sim (BOOL)
- Cfg_ClampMin_EU (REAL)
- Cfg_ClampMax_EU (REAL)
- Cfg_FailSafe_EU (REAL)
Outputs
- CV_Out_EU (REAL)

### 4.10 AOI_PID_FIELD
Inputs
- Cmd : UDT_CMD
- Mode : UDT_MODE
- PV (REAL)
- SP (REAL)
- Track (BOOL)
- TrackValue (REAL)
- Sim (BOOL)
- Cfg_Kp (REAL)
- Cfg_Ti_s (REAL)
- Cfg_Td_s (REAL)
- Cfg_CV_Min (REAL)
- Cfg_CV_Max (REAL)
- Cfg_PV_BadHoldsOutput (BOOL)
Outputs
- CV (REAL)
- Sts : UDT_STS

## 5) Default alarm slot mapping (field-consistent)
Motors (UDT_ALM_SET8)
- A0: ESTOP_LOST (100, Latched)
- A1: OL_TRIP (85, Latched)
- A2: PERM_LOST (60, optionally latched)
- A3: FB_MISMATCH (70, Latched)
- A4: INHIBITED (40, Active)
- A5–A7: spares
