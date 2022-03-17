set -ueo pipefail

source $PROFILE

message "installing Tanzu Application Platform accelerators"

catalog_reset application-platform-accelerator
crumb "adding accelerators"
for acc in $TAP_ACCELERATORS; do
  name=$(basename $acc)
  if ! tanzu accelerator get $name >/dev/null 2>&1; then
    tanzu accelerator create $name --git-repository $acc --git-branch main --interval 15s
  else
    crumb "... $name already installed"
  fi
done
catalog application-platform-accelerator
