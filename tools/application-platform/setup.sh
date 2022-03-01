set -ueo pipefail

source $(dirname $0)/../../etc/profile.sh

ensure cluster-essentials

msg "installing Tanzu Application Platform"

distfile=$DISTFILE_DIR/tanzu-framework-$OS-$ARCH.tar
if [ ! -f $distfile ]; then
  err "distribution not found"
  err "go to: https://network.tanzu.vmware.com/products/tanzu-application-platform/"
  err "and download tanzu-cli-tap-$TANZU_CLI_TAP_VERSION ($(basename $distfile)) and move to the 'distfiles' dir"
  die
fi

set -x
catalog_reset application-platform
git clean -fdx $WORK_DIR
tar xvf $distfile -C $WORK_DIR
cd $WORK_DIR
install cli/core/v${TANZU_CLI_TAP_VERSION}/tanzu-core-${OS}_${ARCH} $LOCAL_DIR/bin/tanzu
tanzu version
tanzu plugin install --local cli all
tanzu plugin list
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
tanzu package repository get tanzu-tap-repository --namespace tap-install
tanzu package available list --namespace tap-install
ytt -f $DATA_DIR/tap-values.yaml \
  -v tanzunet_username=${TANZUNET_USERNAME} \
  -v tanzunet_password=${TANZUNET_PASSWORD} \
  -v docker_username=${DOCKER_USERNAME} \
  -v docker_password=${DOCKER_PASSWORD} \
  --output-files $CONFIG_DIR
chmod u=rw,go=r $CONFIG_DIR/tap-values.yaml
tanzu package install tap -p tap.tanzu.vmware.com -v $TAP_VERSION --values-file $CONFIG_DIR/tap-values.yaml -n tap-install
catalog application-platform
