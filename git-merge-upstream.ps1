[CmdletBinding()]
param (
    [Switch]$Fiddle
)

Set-StrictMode -Version Latest
. $PSScriptRoot\dirs.ps1

function Merge-Personal-Config {
    $rootParent = $env:tmp
    Push-Location $rootParent
    try {
        $rootDir = "$rootParent\_talon"
        $tempConfigName = "talon-config-jme-$(Get-Date -Format 'yyyy-MM-dd_HHmm-ss')"
        $tempConfigDir = "$rootDir\$tempConfigName"

        if ($Fiddle) {
            # below later complained about merging unrelated histories and pulling from upstream got much slower, so not much to be gained from this
            #git clone --no-checkout --depth 1 --filter=tree:0 https://github.com/jmegner/talon-config-jme.git "$tempConfigDir"

            # does not seem faster than the `--filter=blob:none` variant
            git clone --no-checkout --filter=tree:0 https://github.com/jmegner/talon-config-jme.git "$tempConfigDir"
        }
        else {
            git clone --filter=blob:none https://github.com/jmegner/talon-config-jme.git "$tempConfigDir"
        }
        #git clone https://github.com/jmegner/talon-config-jme.git "$tempConfigDir"

        Set-Location "$tempConfigDir"
        git remote add upstream https://github.com/talonhub/community.git
        git pull --no-rebase --no-edit upstream main
        $pullSuccess = $?

        # only the hashes
        $localTipCommit = git log -n 1 --format="%H"
        $remoteOldTipCommit = git log -n 1 --format="%H" origin/main

        if ($pullSuccess) {
            git status
            git push origin main
            Set-Location $rootDir

            if ($localTipCommit -eq $remoteOldTipCommit) {
                Write-Host "no conflicts and no pushed changes; will delete $tempConfigName"
            }
            else {
                Write-Host "no conflicts and pushed some changes; will pull from origin into user and delete $tempConfigName"
                Write-Host "`n`nNow for fast forward"
                Invoke-Expression "$PSScriptRoot\git-fast-forward-all.ps1"
                Write-Host "summary: some pulled changes, no conflicts, so did a personal config push and then did a fast-forward-all"
            }

            Remove-Item -Recurse -Force $tempConfigDir
        }
        else {
            Write-Warning "merge conflicts; resolve them, push from $tempConfigName, pull to user, and delete temp folder"
            code .
            explorer $rootDir
        }
    }
    finally {
        Pop-Location
    }
}

function Merge-Rango {
    Push-Location "$userDir\rango-talon"
    try {
        git pull --no-rebase --no-edit origin main
        $pullSuccess = $?

        if ($pullSuccess) {
        }
        else {
            Write-Warning "merge conflicts; resolve them and commit"
            code .
            explorer $rootDir
        }
    }
    finally {
        Pop-Location
    }
}

Write-Host "=== Merge-Personal-Config ..."
Merge-Personal-Config
Write-Host "`n=== Merge-Rango ..."
Merge-Rango