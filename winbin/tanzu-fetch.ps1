#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

Log-Header "fetching artifacts for TAP $TapVersion"
foreach ($product in $TanzuProducts) {
    Pivnet-Download -Version $TapVersion -Product "$product"
}
