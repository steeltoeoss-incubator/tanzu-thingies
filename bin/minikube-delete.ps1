#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Deleting MiniKube cluster"
Run-Command $MiniKubeCommand delete
Log-Success "MiniKube cluster deleted"
