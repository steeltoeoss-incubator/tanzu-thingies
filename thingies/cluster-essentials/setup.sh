set -ueo pipefail

source $(dirname $0)/../../etc/profile.sh

msg "installing Tanzu Cluster Essentials $TANZU_CLUSTER_ESSENTIALS_VERSION"

distfile=$DISTFILE_DIR/tanzu-cluster-essentials-$OS-$ARCH-$TANZU_CLUSTER_ESSENTIALS_VERSION.tgz
if [ ! -f $distfile ]; then
  err "distribution not found"
  err "go to: https://network.tanzu.vmware.com/products/tanzu-cluster-essentials/"
  err "and download $(basename $distfile) and move to the 'distfiles' dir"
  die
fi

export INSTALL_REGISTRY_HOSTNAME=$TANZUNET_HOSTNAME
export INSTALL_REGISTRY_USERNAME=$TANZUNET_USERNAME
export INSTALL_REGISTRY_PASSWORD=$TANZUNET_PASSWORD
export INSTALL_BUNDLE=$CLUSTER_ESSENTIALS_BUNDLE
export TANZU_CLI_NO_INIT=true

catalog_reset cluster-essentials
git clean -fdx $WORK_DIR
tar xvf $distfile -C $WORK_DIR
cd $WORK_DIR
./install.sh
mkdir -p $LOCAL_DIR/bin
install imgpkg $LOCAL_DIR/bin/imgpkg
install kapp $LOCAL_DIR/bin/kapp
install kbld $LOCAL_DIR/bin/kbld
install ytt $LOCAL_DIR/bin/ytt
catalog cluster-essentials
