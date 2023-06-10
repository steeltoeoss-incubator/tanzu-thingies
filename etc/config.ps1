
$BaseDir = Resolve-Path "$PSScriptRoot/.."
$BinDir = "$BaseDir/bin"
$ConfigDir = "$BaseDir/etc"
$DataDir = "$BaseDir/share"
$LibDir = "$BaseDir/lib"
$LibExecDir = "$BaseDir/libexec"
$TemplateDir = "$DataDir/templates"
$LocalDir = "$BaseDir/local"
$LocalBinDir = "$LocalDir/bin"
$LocalDistDir = "$LocalDir/distfiles"
$LocalToolDir = "$LocalDir/tools"

. "$LibDir/pwsh-functions.ps1"
. "$LibDir/pivnet.ps1"

. "$ConfigDir/platform.ps1"
. "$ConfigDir/tanzu.ps1"
. "$ConfigDir/products.ps1"
. "$ConfigDir/xdg.ps1"


$Overrides = "$ConfigDir/overrides.ps1"
if (Test-Path "$Overrides") {
    . "$Overrides"
}

$Env:PATH="$LocalBinDir;$Env:PATH"
