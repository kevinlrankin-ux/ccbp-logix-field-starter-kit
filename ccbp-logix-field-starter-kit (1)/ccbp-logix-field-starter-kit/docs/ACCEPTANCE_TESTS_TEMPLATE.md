# ACCEPTANCE_TESTS_TEMPLATE.md
Field Commissioning Acceptance Test Template

## 1) Test structure (required)
Each test includes:
- Test ID
- Device
- Preconditions
- Steps
- Expected Results
- Pass/Fail
- Notes

## 2) Motor Starter (DOL) – Test Block

### Test ID
MTR_101_T01_START_BLOCKED_BY_PERMISSIVE

Device
MTR_101

Preconditions
- Controller in RUN
- DI_ESTOP_OK = 1
- DI_MTR_101_OL_OK = 0

Steps
1. Set MTR_101.Cmd.Start = 1
2. Observe output and status

Expected Results
- DO_MTR_101_RUN = 0
- MTR_101.Sts.PermOK = 0
- MTR_101.Sts.Running = 0

Pass/Fail: ☐
Notes:

### Test ID
MTR_101_T02_STOP_DOMINATES_START

Preconditions
- All permissives TRUE
- Motor running

Steps
1. Set MTR_101.Cmd.Start = 1
2. Set MTR_101.Cmd.Stop = 1

Expected Results
- DO_MTR_101_RUN = 0
- MTR_101.Sts.Running = 0

### Test ID
MTR_101_T03_FAULT_LATCH_AND_RESET

Preconditions
- Motor stopped
- Permissives TRUE

Steps
1. Force DI_MTR_101_OL_OK = 0
2. Observe fault latch
3. Restore DI_MTR_101_OL_OK = 1
4. Issue MTR_101.Cmd.Reset = 1

Expected Results
- Fault latches on step 2
- Fault clears only after step 4

## 3) VFD – Test Block
(duplicate the structure per VFD_201)

## 4) Valve – Test Block
(duplicate the structure per VLV_301)

## 5) Analog Input – Test Block
(duplicate the structure per AI_401)

## 6) PID Loop – Test Block
(duplicate the structure per PID_501)

## 7) Final commissioning checklist (required)
☐ All tests executed
☐ All failures resolved or documented
☐ Behavior matches drawings and HMI
☐ Change log updated
☐ Customer sign-off obtained
