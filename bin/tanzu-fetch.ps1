#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

$ErrorActionPreference = "Stop"

. "$PSScriptRoot/../etc/config.ps1"

# Tanzu CLI and Plugins
$slug = $TapSlug
$release = $TapVersion
$archive = ($IsWindows) ? "zip" : "tar"
Pivnet-Download -Slug $slug -Release $release -Platform $PlatformName
Log-Crumb "renaming dist to include release version"
Move-Item -Force "$LocalDistDir/tanzu-framework-$PlatformName-amd64.$archive" $LocalDistDir/tanzu-framework-$PlatformName-amd64-$release.$archive

# Tanzu Cluster Essentials
$slug = $TanzuClusterEssentialsSlug
$release = $TanzuClusterEssentialsVersion
Pivnet-Download -Slug $slug -Release $release -Platform $PlatformName
