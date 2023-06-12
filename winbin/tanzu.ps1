#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Invoke-Expression "${LocalOptDir}/cli/core/v*/tanzu-core-${PlatformName}_amd64${PlatformExe} ${Args}"
