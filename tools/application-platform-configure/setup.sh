set -ueo pipefail

source $(dirname $0)/../../etc/profile.sh

ensure cluster-essentials

msg "configuring Tanzu Application Platform"

distfile=$DISTFILE_DIR/tanzu-framework-$OS-$ARCH.tar
if [ ! -f $distfile ]; then
  err "distribution not found"
  err "go to: https://network.tanzu.vmware.com/products/tanzu-application-platform/"
  err "and download tanzu-cli-tap-$TANZU_CLI_TAP_VERSION ($(basename $distfile)) and move to the 'distfiles' dir"
  die
fi

catalog_reset application-platform-configure
ytt -f $DATA_DIR/tap/minikube \
  -v tanzunet_username=${TANZUNET_USERNAME} \
  -v tanzunet_password=${TANZUNET_PASSWORD} \
  -v docker_username=${DOCKER_USERNAME} \
  -v docker_password=${DOCKER_PASSWORD} \
  --output-files $CONFIG_DIR
chmod u=rw,go=r $CONFIG_DIR/tap-values.yaml
catalog application-platform-configure
