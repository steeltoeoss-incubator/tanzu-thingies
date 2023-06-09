#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

$ErrorActionPreference = "Stop"

. "$PSScriptRoot/../etc/config.ps1"

# Tanzu CLI and Plugins
$slug = $TapSlug
$release = $TapVersion
$archive = ($IsWindows) ? "zip" : "tar"
Pivnet-Download -Slug $slug -Release $release -Platform $PlatformName
