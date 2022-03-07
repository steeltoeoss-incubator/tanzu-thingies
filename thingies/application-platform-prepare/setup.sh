set -ueo pipefail

source $(dirname $0)/../../etc/profile.sh

ensure tanzu-cli

msg "preparing Tanzu Application Platform"

distfile=$DISTFILE_DIR/tanzu-framework-$OS-$ARCH.tar
if [ ! -f $distfile ]; then
  err "distribution not found"
  err "go to: https://network.tanzu.vmware.com/products/tanzu-application-platform/"
  err "and download tanzu-cli-tap-$TANZU_CLI_TAP_VERSION ($(basename $distfile)) and move to the 'distfiles' dir"
  die
fi

catalog_reset application-platform-prepare
if ! kubectl get namespace tap-install >/dev/null 2>&1; then
  kubectl create ns tap-install
fi
tanzu secret registry add tap-registry \
  --server ${TANZUNET_HOSTNAME} \
  --username ${TANZUNET_USERNAME} \
  --password ${TANZUNET_PASSWORD} \
  --export-to-all-namespaces --yes --namespace tap-install
tanzu package repository add tanzu-tap-repository \
  --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${TAP_VERSION} \
  --namespace tap-install
while true; do
  status=$(echo $(tanzu package repository get tanzu-tap-repository --namespace tap-install | grep '^STATUS:' | cut -d: -f2))
  [ "$status" == "Reconcile succeeded" ] && break
  echo "waiting for reconcile to complete ..."
  sleep 1
done
tanzu package available list --namespace tap-install
catalog application-platform-prepare
