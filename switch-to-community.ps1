Move-Item -Path ..\talon-config-jme -Destination ..\..
if (Test-Path -Path ..\..\community) {
    Move-Item -Path ..\..\community -Destination ..
} else {
    git clone https://github.com/talonhub/community.git ..\community
}
