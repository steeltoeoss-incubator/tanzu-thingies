set -ueo pipefail

source $PROFILE

message "installing Tanzu Cluster Essentials $TANZU_CLUSTER_ESSENTIALS_VERSION"

distfile=$DISTFILE_DIR/tanzu-cluster-essentials-$OS-$ARCH-$TANZU_CLUSTER_ESSENTIALS_VERSION.tgz
if [ ! -f $distfile ]; then
  error "distribution not found"
  error "go to: https://network.tanzu.vmware.com/products/tanzu-cluster-essentials/"
  error "and download $(basename $distfile) and move to the 'distfiles' dir"
  die
fi

export INSTALL_REGISTRY_HOSTNAME=$TANZUNET_HOSTNAME
export INSTALL_REGISTRY_USERNAME=$TANZUNET_USERNAME
export INSTALL_REGISTRY_PASSWORD=$TANZUNET_PASSWORD
export INSTALL_BUNDLE=$CLUSTER_ESSENTIALS_BUNDLE
export TANZU_CLI_NO_INIT=true

catalog_reset cluster-essentials-local
init_workdir
cd $(workdir)
crumb "extracting Tanzu Cluster Essentials"
extract $distfile
crumb "installing local Tanzu Cluster Essentials tools"
local_install imgpkg bin/imgpkg
local_install kapp bin/kapp
local_install kbld bin/kbld
local_install ytt bin/ytt
catalog cluster-essentials-local
