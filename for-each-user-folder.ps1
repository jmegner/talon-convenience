[CmdletBinding()]
param (
    [Parameter(Mandatory)]
    [string]
    $Action,

    [Parameter(ValueFromRemainingArguments)]
    [string[]]
    $ExemptFolders
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

[string] $userDir = "$($env:APPDATA)\talon\user\"

Write-Host "for-each-user-folder; Action='$Action'; ExemptFolders='$ExemptFolders'"

Get-ChildItem -Directory $userDir | ForEach-Object {
    Write-Host "`n###########################################"
    if ($ExemptFolders -contains $_.Name -or $_.Name.StartsWith('.')) {
        Write-Host "Skipping $_"
    }
    else {
        Write-Host "Visiting '$_'"
        Push-Location $_
        try {
            Invoke-Expression $Action
        }
        finally {
            Pop-Location
        }
    }
}
