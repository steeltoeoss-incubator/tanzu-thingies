$LocalDir = "$BaseDir/local/$TapVersion"
$LocalConfigDir = "$LocalDir/etc"
$LocalCacheDir = "$LocalDir/var"
$LocalDataDir = "$LocalDir/share"
$LocalOptDir = "$LocalDir/opt"
$Env:XDG_CONFIG_HOME = "$LocalConfigDir"
$Env:XDG_DATA_HOME = "$LocalDataDir"
$Env:XDG_CACHE_HOME = "$LocalCacheDir"
