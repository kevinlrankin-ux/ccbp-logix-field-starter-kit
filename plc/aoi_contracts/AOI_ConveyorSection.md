# AOI Contract — AOI_ConveyorSection

Inputs:
- xEStopOK, xPermExternal, xJamSwitchOK, xFbRunning
- xAutoReq, xManReq
- xStart, xStop, xReset
- iMode

Outputs (wire + mirror publicly):
- xCmdRun
- xFaulted
- diFaultCode
- aAlm[1..8]

Policy:
- NO_AOI_INTERNALS (HMI uses public status tags only)
