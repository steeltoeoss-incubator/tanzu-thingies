#!/usr/bin/env pwsh -NoProfile

#Requires -Version 7.2

. "$PSScriptRoot/../etc/config.ps1"

$infile = "$Env:DATA_DIR/examples/tap-profile.yaml"
$outfile = "$Env:CONFIG_DIR/tap-profile.yaml"

Log-Header "Generating TAP Profile"
if ($IsWindows)
{
    Run-Command envsubst -i $infile -o $outfile
}
else
{
    cat $infile | envsubst > $outfile
}

Log-Success "TAP Profile generated"
$outfile
