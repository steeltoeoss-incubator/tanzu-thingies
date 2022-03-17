set -ueo pipefail

source $PROFILE

message "configuring Tanzu Application Platform"

catalog_reset tap-configure
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
  --ignore-unknown-comments \
  --output-files $CACHE_DIR/tap
chmod u=rw,go=r $CACHE_DIR/tap/tap-values.yaml
catalog tap-configure
