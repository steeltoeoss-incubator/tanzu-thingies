#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

$Version = kubectl get packageinstall -n $TapNamespace tap -o json | jq .status.version
$Version -Replace '"', ""
