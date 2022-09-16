#!/usr/bin/env pwsh -NoProfile

. "$PSScriptRoot/../etc/config.ps1"

$prereq_list = "$Env:CONFIG_DIR/prereqs-$Env:PLATFORM.ps1"
$prereq_script = "$Env:LIBEXEC_DIR/prereq-install-$Env:PLATFORM.ps1"

$prereq_list


if (!(Test-Path "$prereq_list"))
{
    Die "no prereqs configured for platform: $Env:PLATFORM"
}

if (!(Test-Path "$prereq_script"))
{
    Die "no prereq installer for platform: $Env:PLATFORM"
}

. "$prereq_list"
Invoke-Expression $prereq_script
