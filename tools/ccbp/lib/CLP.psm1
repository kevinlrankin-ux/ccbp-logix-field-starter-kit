Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function New-CLPResult {
  param(
    [Parameter(Mandatory=$true)][ValidateSet("PASS","FAIL","WARN")][string]$Status,
    [Parameter(Mandatory=$true)][string]$Code,
    [Parameter(Mandatory=$true)][string]$Message,
    [Parameter(Mandatory=$false)][object[]]$Evidence = @(),
    [Parameter(Mandatory=$false)][string]$NextAction = ""
  )

  return [ordered]@{
    status = $Status
    code = $Code
    message = $Message
    evidence = $Evidence
    next_action = $NextAction
  }
}

function Write-CLPLine {
  param([Parameter(Mandatory=$true)][string]$Text)
  Write-Host $Text
}

Export-ModuleMember -Function New-CLPResult, Write-CLPLine
