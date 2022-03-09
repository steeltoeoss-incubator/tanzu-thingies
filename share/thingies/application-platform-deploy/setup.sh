set -ueo pipefail

source $PROFILE

message "deploying Tanzu Application Platform to $(kubectl config get-contexts | grep '^\*' | awk '{print $2}')"

catalog_reset application-platform-deploy
crumb "installing TAP packages"
tanzu package install tap \
  --package-name tap.tanzu.vmware.com \
  --version $TAP_VERSION \
  --namespace $TAP_INSTALL_NAMESPACE \
  --values-file $CACHE_DIR/tap/tap-values.yaml
catalog application-platform-deploy
