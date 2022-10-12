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
$Env:TAP_BUILDSERVICE_IMAGES = "$TapBuildserviceImages"
$Env:TAP_WORKLOAD_IMAGES = "$TapWorkloadImages"

$template = "$TemplateDir/tap-values.yaml"

Log-Header "Generating TAP Configuration"
Substitute-Env -InFile "$template" -OutFile "$TapProfile"

Log-Success "TAP Configuration generated"
$OutFile
