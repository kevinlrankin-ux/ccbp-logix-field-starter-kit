# TAG PLAN (HMI_POLICY: NO_AOI_INTERNALS)

HMI binds only to:
- CL01_LineStat.*
- CL01_S01_Stat.* .. CL01_S05_Stat.*

HMI SHALL NOT bind to:
- AOI instance tags
- Program-local tags
- Hidden AOI members

## Operator Commands (HMI writes)
- CL01_HMI.xStartLine, xStopLine, xResetLine, xMaintReq
- CL01_HMI.xHOA_Hand, xHOA_Off, xHOA_Auto
- CL01_HMI.xLocalSel, xRemoteSel
- CL01_HMI.xManReq_S01..S05
- CL01_HMI.xInhibit_S01..S05

## Public Line Status (HMI reads)
- CL01_LineStat.iMode
- CL01_LineStat.xEStopOK, xLinePermExternal
- CL01_LineStat.xAnyActive, diFirstOutCode, iTopPriority

## Public Section Status (repeat S01..S05)
- CL01_S0X_Stat.xCmdRun, xFaulted, diFaultCode
- mirrored inputs: xJamOK, xFbRunning, xPE_Entry, xPE_Exit
- requests: xAutoReq, xManReq
- alarms: aAlm[1..8]
