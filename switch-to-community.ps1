. $PSScriptRoot\dirs.ps1

Move-Item -Path "$myConfigActiveDir" -Destination "$talonDir"
if (Test-Path -Path $communityArchiveDir) {
    Move-Item -Path "$communityArchiveDir" -Destination "$userDir"
} else {
    git clone https://github.com/talonhub/community.git $communityActiveDir
}

& 'C:\Program Files\Talon\talon.exe'
