# FactoryTalk Faceplates — Binding Contract (NO_AOI_INTERNALS)

FP_LineOverview binds to:
- CL01_LineStat.*
- CL01_S0X_Stat.* tiles

FP_ConveyorSection commands (HMI writes):
- CL01_HMI.xStartLine / xStopLine / xResetLine
- CL01_HMI.xManReq_S0X
- CL01_HMI.xInhibit_S0X

FP_ConveyorSection status (HMI reads):
- CL01_S0X_Stat.xCmdRun, xFaulted, diFaultCode
- CL01_S0X_Stat.xJamOK, xFbRunning, xPE_Entry, xPE_Exit
- CL01_S0X_Stat.aAlm[1..8]
