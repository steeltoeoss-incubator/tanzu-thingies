set -ueo pipefail

source $(dirname $0)/../../etc/profile.sh

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
git clean -fdx $WORK_DIR
crumb "extracting Tanzu Cluster Essentials"
extract $distfile
cd $WORK_DIR
crumb "installing local Tanzu Cluster Essentials tools"
mkdir -p $LOCAL_DIR/bin
install imgpkg $LOCAL_DIR/bin/imgpkg
install kapp $LOCAL_DIR/bin/kapp
install kbld $LOCAL_DIR/bin/kbld
install ytt $LOCAL_DIR/bin/ytt
catalog cluster-essentials-local
