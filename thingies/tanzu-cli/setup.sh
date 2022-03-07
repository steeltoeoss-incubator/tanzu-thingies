set -ueo pipefail

source $(dirname $0)/../../etc/profile.sh

message "installing Tanzu CLI"

distfile=$DISTFILE_DIR/tanzu-framework-$OS-$ARCH.tar
if [ ! -f $distfile ]; then
  error"distribution not found"
  error "go to: https://network.tanzu.vmware.com/products/tanzu-application-platform/"
  error "and download tanzu-cli-tap-$TANZU_CLI_TAP_VERSION ($(basename $distfile)) and move to the 'distfiles' dir"
  die
fi

set -x
catalog_reset tanzu-cli
init_workdir
tar xvf $distfile -C $WORK_DIR
cd $WORK_DIR
local_install cli/core/v${TANZU_CLI_TAP_VERSION}/tanzu-core-${OS}_${ARCH} bin/tanzu
command -v tanzu
tanzu version
TANZU_CLI_NO_INIT=true \
  tanzu plugin install --local cli all
catalog tanzu-cli
