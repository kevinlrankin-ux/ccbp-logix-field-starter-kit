# MainRoutine Sequencer (Rockwell) — Deterministic Outline

Scan order:
1) AOI_ModeAuthority
2) Line permissives + start/stop conditions
3) Downstream-first AutoReq (S05?S01)
4) AOI_ConveyorSection calls (S01..S05)
5) Copy AOI outputs ? CL01_LineStat + CL01_S0X_Stat (NO_AOI_INTERNALS)
6) Alarm banner rollup (downstream-first first-out) via AOI_AlarmRouter per section
