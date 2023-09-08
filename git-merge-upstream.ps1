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
        git status
        git push origin main
        Write-Host "no conflicts; you can pull from origin into user and delete $tempConfigName"
        Set-Location $rootDir
        explorer $rootDir
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
