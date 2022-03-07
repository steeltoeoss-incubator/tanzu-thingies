set -ueo pipefail

source $(dirname $0)/../../etc/profile.sh

message "deploying Tanzu Application Platform to $(kubectl config get-contexts | grep '^\*' | awk '{print $2}')"

catalog_reset application-platform-deploy
crumb "installing TAP packages"
tanzu package install tap -p tap.tanzu.vmware.com -v $TAP_VERSION --values-file $CONFIG_DIR/tap-values.yaml -n tap-install
catalog application-platform-deploy
