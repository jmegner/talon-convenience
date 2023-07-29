using namespace System.Collections.Generic

[CmdletBinding()]
param (
    [Parameter(Mandatory,ValueFromRemainingArguments)]
    [ValidateCount(1,[int]::MaxValue)]
    [string]
    $Action
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

[string] $userDir = "$($env:APPDATA)\talon\user\"

Get-ChildItem -Directory $userDir | ForEach-Object {
    Write-Host "###########################################"
    Write-Host "Visiting $_"
    Push-Location $_
    try {
        Invoke-Expression $Action
    }
    finally {
        Pop-Location
    }
}
