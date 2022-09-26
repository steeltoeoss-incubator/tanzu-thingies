$TapVersion = "1.3.0-build.23"
$TapSlug = "tanzu-application-platform"
$TapDist = "tanzu-framework-$PlatformName-amd64-$TapVersion.tar"

$TapNamespace = "tap-install"
$TapDevNamespace = "default"
$TapDomain = "local"

$TanzuClusterEssentialsVersion = "1.2.0"
$TanzuClusterEssentialsSlug = "tanzu-cluster-essentials"
$TanzuClusterEssentialsDist = "tanzu-cluster-essentials-$PlatformName-amd64-$TanzuClusterEssentialsVersion.tgz"
$TanzuClusterEssentialsBundle = "registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:e00f33b92d418f49b1af79f42cb13d6765f1c8c731f4528dfff8343af042dc3e"

$Env:TANZU_CLI_NO_INIT = "true"

$TanzuCommand = "$LocalBinDir/tanzu${EXECUTABLE}"

