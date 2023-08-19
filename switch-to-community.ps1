. $PSScriptRoot\dirs.ps1

Move-Item -Path "$userDir\talon-config-jme" -Destination "$talonDir"
if (Test-Path -Path $communityArchiveDir) {
    Move-Item -Path "$communityArchiveDir" -Destination "$userDir"
} else {
    git clone https://github.com/talonhub/community.git $communityActiveDir
}
