set -ueo pipefail

source $(dirname $0)/../../etc/profile.sh

message "deploying Tanzu Application Platform to $(kubectl config get-contexts | grep '^\*' | awk '{print $2}')"

catalog_reset application-platform-deploy
crumb "installing TAP packages"
tanzu package install tap -p tap.tanzu.vmware.com -v $TAP_VERSION --values-file $CONFIG_DIR/tap-values.yaml -n tap-install
crumb "adding accelerators"
for acc in $TAP_ACCELERATORS; do
  name=$(basename $acc)
  crumb " ... $name"
  tanzu acc create $name --git-repository $acc --git-branch main --interval 15s
done
catalog application-platform-deploy
