set -ueo pipefail

source $(dirname $0)/../../etc/profile.sh

message "configuring Tanzu Application Platform"

distfile=$DISTFILE_DIR/tanzu-framework-$OS-$ARCH.tar
if [ ! -f $distfile ]; then
  error "distribution not found"
  error "go to: https://network.tanzu.vmware.com/products/tanzu-application-platform/"
  error "and download tanzu-cli-tap-$TANZU_CLI_TAP_VERSION ($(basename $distfile)) and move to the 'distfiles' dir"
  die
fi

catalog_reset application-platform-configure
resolve_kubernetes_vendor
crumb "creating tap-values"
ytt -f $DATA_DIR/tap/${KUBERNETES_VENDOR} \
  -v tanzunet_username=${TANZUNET_USERNAME} \
  -v tanzunet_password=${TANZUNET_PASSWORD} \
  -v docker_username=${DOCKER_USERNAME} \
  -v docker_password=${DOCKER_PASSWORD} \
  -v tap_domain_name=${TAP_DOMAIN_NAME} \
  -v tap_gui_url=${TAP_GUI_URL} \
  -v tap_catalog=${TAP_CATALOG} \
  --output-files $CONFIG_DIR
chmod u=rw,go=r $CONFIG_DIR/tap-values.yaml
catalog application-platform-configure
