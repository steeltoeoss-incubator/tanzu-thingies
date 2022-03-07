set -ueo pipefail

source $(dirname $0)/../../etc/profile.sh

message "preparing Tanzu Application Platform"

distfile=$DISTFILE_DIR/tanzu-framework-$OS-$ARCH.tar
if [ ! -f $distfile ]; then
  error "distribution not found"
  error "go to: https://network.tanzu.vmware.com/products/tanzu-application-platform/"
  error "and download tanzu-cli-tap-$TANZU_CLI_TAP_VERSION ($(basename $distfile)) and move to the 'distfiles' dir"
  die
fi

namespace=tap-install

catalog_reset application-platform-prepare
if ! kubectl get namespace $namespace >/dev/null 2>&1; then
  crumb "creating namespace $namespace"
  kubectl create ns $namespace
else
  crumb "namespace $namespace already exists"
fi
crumb "adding tap-registry secret"
tanzu secret registry add tap-registry \
  --server ${TANZUNET_HOSTNAME} \
  --username ${TANZUNET_USERNAME} \
  --password ${TANZUNET_PASSWORD} \
  --export-to-all-namespaces --yes --namespace tap-install
crumb "adding tap-registry"
tanzu package repository add tanzu-tap-repository \
  --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${TAP_VERSION} \
  --namespace tap-install
while true; do
  status=$(echo $(tanzu package repository get tanzu-tap-repository --namespace tap-install | grep '^STATUS:' | cut -d: -f2))
  [ "$status" == "Reconcile succeeded" ] && break
  echo "waiting for reconcile to complete ..."
  sleep 1
done
catalog application-platform-prepare
