#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

$PreReqList = "$ConfigDir/prereqs-$PlatformName.ps1"
$PreReqScript = "$LibExecDir/prereq-install-$PlatformName.ps1"

if (!(Test-Path "$PreReqList")) {
    Die "no prereqs configured for platform: $PlatformName"
}

if (!(Test-Path "$PreReqScript")) {
    Die "no prereq installer for platform: $PlatformName"
}

. "$PreReqList"
Invoke-Expression $PreReqScript
