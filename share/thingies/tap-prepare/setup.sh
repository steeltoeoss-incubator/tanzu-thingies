set -ueo pipefail

source $PROFILE

message "preparing Tanzu Application Platform"

catalog_reset tap-prepare
if ! kubectl get namespace $TAP_INSTALL_NAMESPACE >/dev/null 2>&1; then
  crumb "creating namespace $TAP_INSTALL_NAMESPACE"
  kubectl create ns $TAP_INSTALL_NAMESPACE
else
  crumb "namespace $TAP_INSTALL_NAMESPACE already exists"
fi
crumb "creating registry secret"
tanzu secret registry add tap-registry \
  --server ${TANZUNET_HOSTNAME} \
  --username ${TANZUNET_USERNAME} \
  --password ${TANZUNET_PASSWORD} \
  --export-to-all-namespaces --yes --namespace $TAP_INSTALL_NAMESPACE
crumb "adding tap package repository"
tanzu package repository add tanzu-tap-repository \
  --url registry.tanzu.vmware.com/tanzu-application-platform/tap-packages:${TAP_VERSION} \
  --namespace $TAP_INSTALL_NAMESPACE
while true; do
  status=$(echo $(tanzu package repository get tanzu-tap-repository --namespace $TAP_INSTALL_NAMESPACE | grep '^STATUS:' | cut -d: -f2))
  [ "$status" == "Reconcile succeeded" ] && break
  echo "waiting for reconcile to complete ..."
  sleep 1
done
catalog tap-prepare
