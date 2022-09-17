#!/usr/bin/env pwsh -NoProfile
#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "Deleting MiniKube cluster"
MiniKube-Delete
Log-Success "MiniKube cluster deleted"
