$Env:TAP_VERSION = "1.2.2"
$Env:TANZU_ESSENTIALS_VERSION = "1.2.0"

$TapNamespace = "tap-install"
$TapDevNamespace = "default"
$TapDomain = "local"

$TanzuClusterEssentialsVersion = "1.2.0"
$TanzuClusterEssentialsBundle = "registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:e00f33b92d418f49b1af79f42cb13d6765f1c8c731f4528dfff8343af042dc3e"

$Env:TANZU_CLI_NO_INIT = "true"

$Env:INSTALL_BUNDLE = "registry.tanzu.vmware.com/tanzu-cluster-essentials/cluster-essentials-bundle@sha256:e00f33b92d418f49b1af79f42cb13d6765f1c8c731f4528dfff8343af042dc3e"
$Env:INSTALL_REGISTRY_HOSTNAME = "$Env:TANZUNET_HOST"
$Env:INSTALL_REGISTRY_USERNAME = "$Env:TANZUNET_USER"
$Env:INSTALL_REGISTRY_PASSWORD = "$Env:TANZUNET_PASS"

$Env:TANZU_CMD = "$Env:LOCAL_BIN_DIR/tanzu${Env:EXECUTABLE}"
