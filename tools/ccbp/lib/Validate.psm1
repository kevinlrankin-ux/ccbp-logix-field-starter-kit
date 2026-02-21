Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Invoke-CCBPValidate {
  param(
    [Parameter(Mandatory=$true)][string]$RepoRoot,
    [Parameter(Mandatory=$true)][object]$Contract,
    [Parameter(Mandatory=$true)][object]$AspPosture
  )

  New-CCBPDir (Join-Path $RepoRoot "artifacts")

  $evidence = @()

  # Validate that every contract-declared input path exists
  foreach ($k in $Contract.inputs.PSObject.Properties.Name) {
    $paths = @($Contract.inputs.$k)
    foreach ($rel in $paths) {
      $abs = Join-Path $RepoRoot $rel
      $ok = Test-Path $abs
      $evidence += [ordered]@{
        check = "input_exists"
        input_type = $k
        path = $rel
        exists = $ok
      }
    }
  }

  $missing = @($evidence | Where-Object { $_.check -eq "input_exists" -and $_.exists -eq $false })
  $status = if ($missing.Length -gt 0) { "FAIL" } else { "PASS" }

  $result = New-CLPResult `
    -Status $status `
    -Code "CCBP.VALIDATE.INPUTS" `
    -Message "Validated contract-declared inputs exist." `
    -Evidence $evidence `
    -NextAction ($(if ($status -eq "FAIL") { "Create missing input files OR update CONTRACT_INDEX.json inputs to correct paths." } else { "" }))

  $manifest = [ordered]@{
    schema = "ccbp.build_manifest.v1"
    status = $result.status
    repo = [ordered]@{
      name = $Contract.repo.name
      platform = $Contract.repo.platform
      profile = $Contract.repo.profile
    }
    asp_posture = $AspPosture
    result = $result
    generated_at_utc = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
  }

  $out = Join-Path $RepoRoot "artifacts\BUILD_MANIFEST.json"
  ($manifest | ConvertTo-Json -Depth 30) | Set-Content -Path $out -Encoding UTF8

  Write-CLPLine "CCBP validate => $status"
  Write-CLPLine "Wrote: artifacts/BUILD_MANIFEST.json"
}

function Invoke-CCBPBuild {
  param(
    [Parameter(Mandatory=$true)][string]$RepoRoot,
    [Parameter(Mandatory=$true)][object]$Contract,
    [Parameter(Mandatory=$true)][object]$AspPosture
  )
  Invoke-CCBPValidate -RepoRoot $RepoRoot -Contract $Contract -AspPosture $AspPosture
}

Export-ModuleMember -Function Invoke-CCBPValidate, Invoke-CCBPBuild

