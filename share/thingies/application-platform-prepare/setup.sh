set -ueo pipefail

source $PROFILE

message "preparing Tanzu Application Platform"

distfile=$DISTFILE_DIR/tanzu-framework-$OS-$ARCH.tar
if [ ! -f $distfile ]; then
  error "distribution not found"
  error "go to: https://network.tanzu.vmware.com/products/tanzu-application-platform/"
  error "and download tanzu-cli-tap-$TANZU_CLI_TAP_VERSION ($(basename $distfile)) and move to the 'distfiles' dir"
  die
fi

catalog_reset application-platform-prepare
if ! kubectl get namespace $TAP_INSTALL_NAMESPACE >/dev/null 2>&1; then
  crumb "creating namespace $TAP_INSTALL_NAMESPACE"
  kubectl create ns $TAP_INSTALL_NAMESPACE
else
  crumb "namespace $TAP_INSTALL_NAMESPACE already exists"
fi
crumb "adding tap-registry secret"
tanzu secret registry add tap-registry \
  --server ${TANZUNET_HOSTNAME} \
  --username ${TANZUNET_USERNAME} \
  --password ${TANZUNET_PASSWORD} \
  --export-to-all-namespaces --yes --namespace $TAP_INSTALL_NAMESPACE
crumb "adding tap-registry"
tanzu package repository add tanzu-tap-repository \
  --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${TAP_VERSION} \
  --namespace $TAP_INSTALL_NAMESPACE
while true; do
  status=$(echo $(tanzu package repository get tanzu-tap-repository --namespace $TAP_INSTALL_NAMESPACE | grep '^STATUS:' | cut -d: -f2))
  [ "$status" == "Reconcile succeeded" ] && break
  echo "waiting for reconcile to complete ..."
  sleep 1
done
catalog application-platform-prepare
