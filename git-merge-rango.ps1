. $PSScriptRoot\dirs.ps1

Push-Location $rangoDir
try {
    Write-Host "###########################################"
    Write-Host "merging rango"
    git pull origin main --no-rebase --no-edit
}
finally {
    Pop-Location
}