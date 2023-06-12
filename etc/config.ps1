
$BaseDir = Resolve-Path "$PSScriptRoot/.."
$ConfigDir = "$BaseDir/etc"
$DataDir = "$BaseDir/share"
$LibDir = "$BaseDir/lib"
$LibExecDir = "$BaseDir/libexec"
$TemplateDir = "$DataDir/templates"

. "$LibDir/pwsh-functions.ps1"
. "$LibDir/pivnet.ps1"

. "$ConfigDir/platform.ps1"
. "$ConfigDir/products.ps1"
. "$ConfigDir/tap.ps1"

$Overrides = "$ConfigDir/overrides.ps1"
if (Test-Path "$Overrides") {
    . "$Overrides"
}

if (Test-Path env:TT_TAP_VERSION) {
    $TapVersion = $env:TT_TAP_VERSION
}

. "$ConfigDir/local.ps1"
