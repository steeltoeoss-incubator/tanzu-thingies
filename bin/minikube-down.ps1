#!/usr/bin/env pwsh -NoProfile
#Requires -Version 7.2

$ErrorActionPreference = "Stop"

. "$PSScriptRoot/../etc/config.ps1"

MiniKube-Stop
