#!/usr/bin/env pwsh -NoProfile
#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Stopping MiniKube cluster"
MiniKube-Stop
Log-Success "MiniKube cluster stopped"
