set -ueo pipefail

source $PROFILE

message "installing Tanzu CLI"

distfile=$DISTFILE_DIR/tanzu-framework-$OS-$ARCH.tar
if [ ! -f $distfile ]; then
  error "distribution not found"
  error "go to: https://network.tanzu.vmware.com/products/tanzu-application-platform/"
  error "and download tanzu-cli-tap-$TANZU_CLI_TAP_VERSION ($(basename $distfile)) and move to the distfiles dir"
  die
fi

export TANZU_CLI_NO_INIT=true

catalog_reset tanzu-cli
crumb "removing existing tanzu CLI, pliugins, associated files"
rm -rf $TANZU_CLI_HOME/cli
rm -rf ~/.config/tanzu/
rm -rf ~/.tanzu/
rm -rf ~/.cache/tanzu/
rm -rf ~/Library/Application\ Support/tanzu-cli/*
rm -f $LOCAL_DIR/bin/tanzu
crumb "extracting tanzu CLI"
cd $(init_dir $TANZU_CLI_HOME)
extract $distfile
crumb "installing tanzu CLI"
local_install cli/core/v${TANZU_CLI_TAP_VERSION}/tanzu-core-${OS}_${ARCH} bin/tanzu
tanzu version
crumb "installing tanzu CLI plugins"
tanzu plugin install --local cli all
crumb "listing tanzu CLI plugins"
tanzu plugin list
catalog tanzu-cli
