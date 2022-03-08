set -ueo pipefail

source $PROFILE

message "installing Tanzu CLI"

distfile=$DISTFILE_DIR/tanzu-framework-$OS-$ARCH.tar
if [ ! -f $distfile ]; then
  error"distribution not found"
  error "go to: https://network.tanzu.vmware.com/products/tanzu-application-platform/"
  error "and download tanzu-cli-tap-$TANZU_CLI_TAP_VERSION ($(basename $distfile)) and move to the 'distfiles' dir"
  die
fi

catalog_reset tanzu-cli
init_workdir
cd $(workdir)
crumb "extracting tanzu CLI"
extract $distfile
crumb "installing tanzu CLI"
local_install cli/core/v${TANZU_CLI_TAP_VERSION}/tanzu-core-${OS}_${ARCH} bin/tanzu
crumb "installing tanzu CLI plugins"
TANZU_CLI_NO_INIT=true \
  tanzu plugin install --local cli all
catalog tanzu-cli
