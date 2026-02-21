Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-ASPPosture {
  param(
    [Parameter(Mandatory=$true)][string]$RepoRoot,
    [Parameter(Mandatory=$true)][object]$Contract
  )

  $isCI = [bool]$env:CI
  $posture = [ordered]@{
    is_ci = $isCI
    allow_code_generation = [bool]$Contract.gates.allow_code_generation
    allow_plc_project_mutation = [bool]$Contract.gates.allow_plc_project_mutation
  }

  if ($isCI) {
    $posture.allow_plc_project_mutation = $false
  }

  return $posture
}

Export-ModuleMember -Function Get-ASPPosture
