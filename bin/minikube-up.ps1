#!/usr/bin/env pwsh -NoProfile
#Requires -Version 7.2

$ErrorActionPreference = "Stop"

. "$PSScriptRoot/../etc/config.ps1"

If ((MiniKube-Status) -eq [MiniKubeStatus]::Absent)
{
    MiniKube-Create
}
ElseIf ((MiniKube-Status) -eq [MiniKubeStatus]::Stopped)
{
    MiniKube-Start
}
MiniKube-Tunnel
