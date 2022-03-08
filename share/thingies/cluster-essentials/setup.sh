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

catalog_reset cluster-essentials
init_workdir
cd $(workdir)
crumb "extracting Tanzu Cluster Essentials"
extract $distfile
crumb "installing Tanzu Cluster Essentials in cluster"
./install.sh
catalog cluster-essentials
