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
crumb "adding accelerators"
for acc in $TAP_ACCELERATORS; do
  name=$(basename $acc)
  if ! tanzu accelerator get $name; then
    tanzu accelerator create $name --git-repository $acc --git-branch main --interval 15s
  fi
done
catalog application-platform-deploy
