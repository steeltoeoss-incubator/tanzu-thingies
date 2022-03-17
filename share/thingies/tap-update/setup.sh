set -ueo pipefail

source $PROFILE

message "deploying Tanzu Application Platform to $(kubectl config get-contexts | grep '^\*' | awk '{print $2}')"

catalog_reset application-platform-deploy
crumb "installing TAP packages"
tanzu package installed update tap \
  --package-name tap.tanzu.vmware.com \
  --namespace $TAP_INSTALL_NAMESPACE \
  --values-file $CACHE_DIR/tap/tap-values.yaml
catalog application-platform-deploy
