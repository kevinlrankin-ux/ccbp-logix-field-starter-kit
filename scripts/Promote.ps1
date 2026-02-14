param(
  [string]$CrPath = "changes/CR-0001"
)

$RepoRoot    = Get-Location
$Envelope    = Join-Path $RepoRoot (Join-Path $CrPath "envelope.yaml")
$Draft       = Join-Path $RepoRoot (Join-Path $CrPath "draft_ladder_candidate.txt")
$LabelPath   = Join-Path $RepoRoot (Join-Path $CrPath "label_oh-01.json")
$StampPath   = Join-Path $RepoRoot (Join-Path $CrPath "stamp.yaml")
$ApprovedDir = Join-Path $RepoRoot "plc\approved"

function Fail([string]$Msg) { Write-Host "PROMOTE BLOCKED: $Msg" -ForegroundColor Red; exit 1 }

if (!(Test-Path $Envelope))  { Fail "Missing envelope.yaml" }
if (!(Test-Path $Draft))     { Fail "Missing draft_ladder_candidate.txt" }
if (!(Test-Path $LabelPath)) { Fail "Missing label_oh-01.json (run OH-01_Label.ps1)" }
if (!(Test-Path $StampPath)) { Fail "Missing stamp.yaml (run Stamp.ps1)" }

# Minimal "Operational" check: envelope contains core CCBP invariant sections
$Env = Get-Content $Envelope -Raw
$OpTokens = @("ccbp_assertions:", "authority_boundary_statement:", "risk_flags:", "execution_gate:")
foreach ($t in $OpTokens) {
  if ($Env -notmatch [regex]::Escape($t)) { Fail "Envelope not operational (missing token: $t)" }
}

# Verify stamp seals to label hash
$Label = Get-Content $LabelPath -Raw | ConvertFrom-Json
$Hash  = $Label.structure_hash_sha256
$StampText = Get-Content $StampPath -Raw

if ($StampText -notmatch [regex]::Escape($Hash)) {
  Fail "Stamp does not match OH-01 label hash. Re-run OH-01 then re-stamp."
}

if (!(Test-Path $ApprovedDir)) { New-Item -ItemType Directory -Path $ApprovedDir | Out-Null }

# Promote draft artifact (approved path)
$Out = Join-Path $ApprovedDir ("CR-0001_Approved.txt")
Copy-Item $Draft $Out -Force

Write-Host "PROMOTED: $Out" -ForegroundColor Green
exit 0


# ------------------------------------------------
# REAL Guardrail: require SIM validation reference
# ------------------------------------------------
if ($Env -match 'external_impact:\s*"?YES"?' ) {

    if ($Env -notmatch 'required_previous_sim_hash:\s*".+?"') {
        Fail "REAL promotion requires required_previous_sim_hash."
    }

    $SimHash = ([regex]::Match($Env,'required_previous_sim_hash:\s*"?(.+?)"?')).Groups[1].Value

    if (-not (Get-ChildItem -Recurse -Filter "label_oh-01.json" | 
              Where-Object { (Get-Content .FullName -Raw) -match $SimHash })) {

        Fail "Referenced SIM hash not found in repository."
    }
}


# ------------------------------------------------
# LEDGER_SIM_REQUIRED:
# If this envelope is REAL-transition (external_impact=YES),
# require required_previous_sim_hash AND require it be registered in ledger with scope=SIM.
# ------------------------------------------------
\ = Join-Path \C:\Users\kevlr\OneDrive\Downloads\ccbp-rockwell-conveyor-line "ledger\hash_registry.jsonl"

if (\envelope:
  artifact_id: "ENVELOPE-CR-0002-REALIZATION"
  version: "v0.1"
  origin: "ccbp-rockwell-conveyor-line"
  owner_human: "Kevin Rankin"

scope:
  definition: |
    TRANSITION ENVELOPE.
    Converts SIM validated artifact into REAL deployment request.

execution_gate:
  external_impact: "YES"
  required_previous_sim_hash: "<INSERT_SIM_HASH_HERE>"
  sim_validation_required: true

ccbp_assertions:
  triad_required: true
  authority_remains_human: true

notes:
  sim_tools_must_refuse: true -match '(?m)^\s*external_impact\s*:\s*"?YES"?' ) {

  if (!(Test-Path \)) { Fail "Missing ledger/hash_registry.jsonl for REAL transition enforcement." }

  \ = [regex]::Match(\envelope:
  artifact_id: "ENVELOPE-CR-0002-REALIZATION"
  version: "v0.1"
  origin: "ccbp-rockwell-conveyor-line"
  owner_human: "Kevin Rankin"

scope:
  definition: |
    TRANSITION ENVELOPE.
    Converts SIM validated artifact into REAL deployment request.

execution_gate:
  external_impact: "YES"
  required_previous_sim_hash: "<INSERT_SIM_HASH_HERE>"
  sim_validation_required: true

ccbp_assertions:
  triad_required: true
  authority_remains_human: true

notes:
  sim_tools_must_refuse: true,'(?m)^\s*required_previous_sim_hash\s*:\s*"?(.+?)"?\s*$')
  if (!\.Success) { Fail "REAL transition requires required_previous_sim_hash in envelope.yaml" }
  \ = \.Groups[1].Value.Trim()

  \ = \False
  \ = Get-Content \ -ErrorAction SilentlyContinue
  foreach (\ in \) {
    if (\ -match [regex]::Escape(\)) {
      if (\ -match '"scope"\s*:\s*"SIM"' -or \ -match '"scope":"SIM"') {
        \ = \True
        break
      }
    }
  }

  if (-not \) {
    Fail "SIM hash not registered in ledger (scope=SIM). Run scripts/Register-Hash.ps1 -Scope SIM, or re-SIM-stamp with auto-ledger."
  }
}
# LEDGER_SIM_REQUIRED
