$rootParent = $env:tmp
Push-Location $rootParent
try {
    $rootDir = "$rootParent\_talon"
    $tempConfigName = "talon-config-jme-$(Get-Date -Format 'yyyy-MM-dd_HHmm')"
    $tempConfigDir = "$rootDir\$tempConfigName"
    git clone https://github.com/jmegner/talon-config-jme.git "$tempConfigDir"
    Set-Location "$tempConfigDir"
    git remote add community https://github.com/talonhub/community.git
    git pull community main
    if ($?) {
        Write-Host "no conflicts"
        git status
        git push origin main
        Set-Location $rootDir
        explorer $rootDir
    }
    else {
        Write-Warning "merge conflicts"
        code .
        explorer $rootDir
    }
}
finally {
    Pop-Location
}
