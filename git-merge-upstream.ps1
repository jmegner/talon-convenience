$rootParent = $env:tmp
Push-Location $rootParent
try {
    $rootDir = "$rootParent\_talon"
    $tempConfigName = "talon-config-jme-$(Get-Date -Format 'yyyy-MM-dd_HHmm')"
    $tempConfigDir = "$rootDir\$tempConfigName"

    git clone --filter=blob:none https://github.com/jmegner/talon-config-jme.git "$tempConfigDir"

    Set-Location "$tempConfigDir"
    git remote add upstream https://github.com/talonhub/community.git
    git pull upstream main
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
            Invoke-Expression "$PSScriptRoot\git-fast-forward-all.ps1"
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
