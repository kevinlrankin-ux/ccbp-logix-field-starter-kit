param(
  [string]$CrPath = "changes/CR-0001"
)

$RepoRoot = Get-Location
$EnvelopePath = Join-Path $RepoRoot (Join-Path $CrPath "envelope.yaml")
$DraftPath    = Join-Path $RepoRoot (Join-Path $CrPath "draft_ladder_candidate.txt")
$LabelPath    = Join-Path $RepoRoot (Join-Path $CrPath "label_oh-01.json")

function Fail([string]$Msg) {
  Write-Host "OH-01 FAIL: $Msg" -ForegroundColor Red
  exit 1
}

if (!(Test-Path $EnvelopePath)) { Fail "Missing envelope: $EnvelopePath" }
if (!(Test-Path $DraftPath))    { Fail "Missing draft: $DraftPath" }

# --- Minimal YAML presence checks (lightweight; structure-focused) ---
$EnvText = Get-Content $EnvelopePath -Raw

$RequiredTokens = @(
  "envelope:",
  "artifact_id:",
  "ccbp_assertions:",
  "authority_boundary_statement:",
  "content_pointers:",
  "spec_targets:",
  "test_targets:"
)

foreach ($t in $RequiredTokens) {
  if ($EnvText -notmatch [regex]::Escape($t)) { Fail "Envelope missing token: $t" }
}

# --- Draft structure checks (must contain required section headers) ---
$DraftText = Get-Content $DraftPath -Raw
$DraftSections = @(
  "DRAFT LADDER CANDIDATE",
  "1) TAGS USED",
  "2) GLOBAL PERMISSIVE LOGIC",
  "3) JAM UPSTREAM-ONLY LOGIC",
  "4) START ORDER LOGIC",
  "5) STOP DOMINANCE",
  "6) TEST TRACEABILITY MATRIX",
  "7) CCBP COMPLIANCE NOTES"
)

foreach ($s in $DraftSections) {
  if ($DraftText -notmatch [regex]::Escape($s)) { Fail "Draft missing section: $s" }
}

# --- Canonicalize + hash (Option C: structural hash) ---
# Canonical structure string = required tokens + required draft section headers in order.
$Canonical = @()
$Canonical += "OH-01::STRUCTURE::v1"
$Canonical += "ENV_TOKENS::" + ($RequiredTokens -join "|")
$Canonical += "DRAFT_SECTIONS::" + ($DraftSections -join "|")

$CanonicalString = ($Canonical -join "
").Trim()

# SHA-256
$Bytes = [System.Text.Encoding]::UTF8.GetBytes($CanonicalString)
$Sha = [System.Security.Cryptography.SHA256]::Create()
$Hash = ($Sha.ComputeHash($Bytes) | ForEach-Object { $_.ToString("x2") }) -join ""

# Emit label (anti-mimicry attestation)
$Label = @{
  oh_step = "OH-01"
  label_type = "STRUCTURE"
  version = "v1"
  cr_path = $CrPath
  envelope_path = $EnvelopePath
  draft_path = $DraftPath
  canonicalization = @{
    env_required_tokens = $RequiredTokens
    draft_required_sections = $DraftSections
  }
  structure_hash_sha256 = $Hash
  created_utc = (Get-Date).ToUniversalTime().ToString("o")
}

$Json = $Label | ConvertTo-Json -Depth 8
Set-Content -Path $LabelPath -Value $Json -Encoding UTF8

Write-Host "OH-01 PASS. Label emitted:" -ForegroundColor Green
Write-Host $LabelPath -ForegroundColor Green
Write-Host "STRUCTURE HASH (SHA-256): $Hash" -ForegroundColor Cyan
exit 0
