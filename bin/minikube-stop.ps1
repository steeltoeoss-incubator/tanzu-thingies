#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Stopping MiniKube cluster"
Run-Command $MiniKubeCommand stop
Log-Success "MiniKube cluster stopped"
