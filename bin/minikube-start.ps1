#!/usr/bin/env pwsh -NoProfile
#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Starting MiniKube cluster"
MiniKube-Start
Log-Success "MiniKube cluster started"
