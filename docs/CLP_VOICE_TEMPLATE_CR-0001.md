\# CLP Voice Prompt Template — CR-0001 (Deterministic Regeneration)



\## Purpose

This prompt template is the canonical CLP invocation contract for generating

a DRAFT ladder candidate that is:



\- Spec-bound (spec/conveyor\_line\_5zone.yaml)

\- Test-bound (tests/fat\_sat\_tests.yaml)

\- CCBP/ASP governed (non-executable, authority-preserving)

\- Deterministic (idempotent structure across runs)



\## Where the output goes

The draft artifact MUST be written to:



\- changes/CR-0001/draft\_ladder\_candidate.txt



\## CCBP “Level Deeper” Assertions (Preamble)

These assertions are required for posture integrity and drift prevention:



\- \[Book I-1] Capability ≠ Authority

\- \[Book I-2] Interpretation authority remains human; outputs are proposals only

\- \[Book II-5] No silent escalation in autonomy, scope, or external impact

\- \[Appendix A-4] Any unresolved risk flag blocks execution and promotion



\## The Template (Copy/Paste)

```text

CLP MODE: INDUSTRIAL\_LOGIX\_DRAFT

GOVERNANCE: CCBP + ASP ENVELOPE ACTIVE

EXECUTION: PROHIBITED

OUTPUT\_TARGET: changes/CR-0001/draft\_ladder\_candidate.txt



=====================================================================

CCBP ASSERTIONS (LEVEL DEEPER — PREAMBLE)

=====================================================================



ASSERT \[Book I-1]: Capability ≠ Authority.

ASSERT \[Book I-2]: Interpretation authority remains human; outputs are proposals only.

ASSERT \[Book II-5]: No silent escalation in autonomy, scope, or external impact.

ASSERT \[Appendix A-4]: Any unresolved risk flag blocks execution and promotion.



POSTURE:

\- This run produces DRAFT artifacts only.

\- No deployment, no PLC download, no external side effects.

\- Any ambiguity must be surfaced as a BLOCKER, not “handled creatively.”



=====================================================================

INPUT CONTRACT

=====================================================================



You are provided:



1\) spec/conveyor\_line\_5zone.yaml

2\) tests/fat\_sat\_tests.yaml



These two files are the ONLY behavioral authorities.



You must derive ladder logic that satisfies the tests exactly.

You may NOT introduce new behaviors not required by tests.



=====================================================================

BEHAVIORAL PRIORITY ORDER (NON-NEGOTIABLE)

=====================================================================



1\. FAT/SAT tests override interpretation.

2\. E-Stop dominance overrides everything.

3\. Line permissive overrides sequencing.

4\. Jam policy must match test definition.

5\. Start order must match spec-defined order.

6\. No safety tag modification.

7\. No creative expansion.



=====================================================================

OUTPUT FORMAT (MANDATORY — NO DEVIATION)

=====================================================================



You MUST generate the draft using EXACTLY the following section order:



1\) HEADER BLOCK

2\) TAGS USED

3\) GLOBAL PERMISSIVE LOGIC

4\) JAM UPSTREAM-ONLY LOGIC

5\) START ORDER LOGIC

6\) STOP DOMINANCE

7\) TEST TRACEABILITY MATRIX

8\) CCBP COMPLIANCE NOTES



No extra sections.

No reordering.

No omissions.



=====================================================================

DERIVATION RULES

=====================================================================



A) Parse spec/tag\_dictionary for:

&nbsp;  - Inputs

&nbsp;  - Outputs

&nbsp;  - Jam feedback signals



B) Parse FAT/SAT tests for:

&nbsp;  - Dominant stop conditions

&nbsp;  - Jam behavior

&nbsp;  - Ordering requirements



C) Jam rule must follow:



If zone k jams:

\- Stop zone k

\- Stop all upstream zones

\- Allow downstream zones to continue



D) Start ordering must follow spec/line/sequencing.start\_order



E) Stop ordering must follow spec/line/sequencing.stop\_order



F) Timing logic:

If tests do NOT explicitly validate timing,

DO NOT implement timers in baseline draft.



=====================================================================

LADDER INSTRUCTION CONSTRAINTS

=====================================================================



Allowed instruction concepts:

\- Boolean gating

\- Derived permissive bits

\- Structured upstream allow bits

\- Deterministic ordering



Disallowed:

\- OTL/OTU unless explicitly required by test

\- AOI internal access

\- HMI bindings

\- Timer complexity unless test demands

\- Additional safety behaviors not defined in test



=====================================================================

DETERMINISM RULE

=====================================================================



Given identical spec + test inputs,

output MUST be structurally identical every time.



Do not rephrase headers.

Do not alter section order.

Do not add explanatory commentary beyond defined sections.



=====================================================================

OUTPUT NOW

=====================================================================



Generate the draft ladder candidate exactly according to format.



