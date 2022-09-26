#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

$ErrorActionPreference = "Stop"

. "$PSScriptRoot/../etc/config.ps1"

# Tanzu CLI and Plugins
$slug = $TapSlug
$release = $TapVersion
$platform = $PlatformName
Pivnet-Download -Slug $slug -Release $release -Platform $platform
Log-Crumb "renameing dist to include release version"
Move-Item $LocalDistDir/tanzu-framework-$platform-amd64.tar $LocalDistDir/tanzu-framework-$platform-amd64-$release.tar

# Tanzu Cluster Essentials
$slug = $TanzuClusterEssentialsSlug
$release = $TanzuClusterEssentialsVersion
$platform = $PlatformName
Pivnet-Download -Slug $slug -Release $release -Platform $platform
