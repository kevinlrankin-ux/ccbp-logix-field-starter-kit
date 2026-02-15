param(
  [string]$CrPath = "changes/CR-0001"
)

$RepoRoot    = Get-Location
$CrFull      = Join-Path $RepoRoot $CrPath

$Envelope    = Join-Path $CrFull "envelope.yaml"
$Draft       = Join-Path $CrFull "draft_ladder_candidate.txt"
$LabelPath   = Join-Path $CrFull "label_oh-01.json"
$StampPath   = Join-Path $CrFull "stamp.yaml"

$ApprovedDir = Join-Path $RepoRoot "plc\approved"
$LedgerPath  = Join-Path $RepoRoot "ledger\hash_registry.jsonl"

function Fail([string]$Msg) { Write-Host "PROMOTE BLOCKED: $Msg" -ForegroundColor Red; exit 1 }

if (!(Test-Path $Envelope))  { Fail "Missing envelope.yaml at $CrPath" }
if (!(Test-Path $Draft))     { Fail "Missing draft_ladder_candidate.txt at $CrPath" }
if (!(Test-Path $LabelPath)) { Fail "Missing label_oh-01.json (run scripts/OH-01_Label.ps1 first)" }
if (!(Test-Path $StampPath)) { Fail "Missing stamp.yaml (run scripts/Stamp.ps1 first)" }

$EnvText = Get-Content $Envelope -Raw

# -----------------------------
# STRICT Operational check
# -----------------------------
$OpTokens = @("ccbp_assertions:", "authority_boundary_statement:", "risk_flags:", "execution_gate:")
foreach ($t in $OpTokens) {
  if ($EnvText -notmatch [regex]::Escape($t)) { Fail "Not Operational: missing envelope section: $t" }
}

# -----------------------------
# Mirror-lock references required
# -----------------------------
$MustRef = @(
  "docs/CLP_LOGIX_MAPPING_CR-0001.md",
  "docs/TAG_BINDING_NORMALIZATION.md",
  "docs/CCBP_BEHAVIOR_CONTRACT_CR-0001.md",
  "changes/CR-0001/archon_questions.md"
)

foreach ($r in $MustRef) {
  if ($EnvText -notmatch [regex]::Escape($r)) { Fail "Not Operational: missing source_ref: $r" }
  $p = Join-Path $RepoRoot $r
  if (!(Test-Path $p)) { Fail "Not Operational: referenced mirror-lock file missing: $r" }
}

# -----------------------------
# Verify stamp seals to label hash
# -----------------------------
$Label = Get-Content $LabelPath -Raw | ConvertFrom-Json
$Hash  = $Label.structure_hash_sha256
if ([string]::IsNullOrWhiteSpace($Hash)) { Fail "Label hash missing/empty in label_oh-01.json" }

$StampText = Get-Content $StampPath -Raw
if ($StampText -notmatch [regex]::Escape($Hash)) {
  Fail "Stamp does not match OH-01 label hash. Re-run OH-01 then re-stamp."
}

# -------------------------------------------------------------------
# REAL TRANSITION ENFORCEMENT (only if this envelope declares impact)
# If execution_gate.external_impact == YES:
#   - required_previous_sim_hash MUST exist
#   - ledger MUST contain that hash with scope=SIM
# -------------------------------------------------------------------
$ExternalImpactYes = ($EnvText -match '(?m)^\s*external_impact\s*:\s*"?YES"?\s*$')
if ($ExternalImpactYes) {

  if (!(Test-Path $LedgerPath)) { Fail "Missing ledger/hash_registry.jsonl (required when external_impact=YES)" }

  $m = [regex]::Match($EnvText,'(?m)^\s*required_previous_sim_hash\s*:\s*"?(.+?)"?\s*$')
  if (!$m.Success) { Fail "external_impact=YES requires execution_gate.required_previous_sim_hash in envelope.yaml" }
  $SimHash = $m.Groups[1].Value.Trim()
  if ([string]::IsNullOrWhiteSpace($SimHash)) { Fail "required_previous_sim_hash is empty" }

  $FoundSim = $false
  foreach ($ln in (Get-Content $LedgerPath -ErrorAction SilentlyContinue)) {
    if ($ln -match [regex]::Escape($SimHash)) {
      if ($ln -match '"scope"\s*:\s*"SIM"' -or $ln -match '"scope":"SIM"') { $FoundSim = $true; break }
    }
  }

  if (-not $FoundSim) {
    Fail "SIM hash not registered in ledger as scope=SIM. Register SIM first (Emulate repo) before REAL promotion."
  }
}

# -----------------------------
# Promote output
# -----------------------------
if (!(Test-Path $ApprovedDir)) { New-Item -ItemType Directory -Path $ApprovedDir | Out-Null }

$Out = Join-Path $ApprovedDir ("CR-0001_Approved.txt")
Copy-Item $Draft $Out -Force

Write-Host "PROMOTED: $Out" -ForegroundColor Green
exit 0
