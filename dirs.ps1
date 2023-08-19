Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
[string] $talonDir = "$($env:APPDATA)/talon"
[string] $userDir = "$talonDir/user"
[string] $communityArchiveDir = "$talonDir/community"
[string] $communityActiveDir = "$userDir/community"
[string] $myConfigArchiveDir = "$talonDir/talon-config-jme"
[string] $myConfigActiveDir = "$userDir/talon-config-jme"
