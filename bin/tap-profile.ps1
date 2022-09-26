#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

$Env:REGISTRY_HOST = "$RegistryHost"
$Env:REGISTRY_USER = "$RegistryUser"
$Env:REGISTRY_PASS = "$RegistryPass"
$Env:REGISTRY_REPO = "$RegistryRepo"

$Env:TANZUNET_HOST = "$TanzuNetHost"
$Env:TANZUNET_USER = "$TanzuNetUser"
$Env:TANZUNET_PASS = "$TanzuNetPass"

$Env:TAP_DOMAIN = "$TapDomain"

$InFile = "$DataDir/templates/tap-profile.yaml"
$OutFile = "$ConfigDir/tap-profile.yaml"

Log-Header "Generating TAP Profile"
Substitute-Env -InFile "$InFile" -OutFile "$OutFile"

Log-Success "TAP Profile generated"
$OutFile
