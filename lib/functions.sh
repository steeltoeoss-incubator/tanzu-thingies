die() {
  [ $# -gt 0 ] && error "$*"
  exit 1
}

message() {
  tput setaf 2
  echo "=== $*"
  tput sgr0
}

crumb() {
  tput setaf 4
  echo "--- $*"
  tput sgr0
}

error() {
  tput setaf 1
  echo "!!! $*" >&2
  tput sgr0
}

b() {
  tput bold
  printf "%s" "$*"
  tput sgr0
}

u() {
  tput smul
  printf "%s" "$*"
  tput rmul
}

s() {
  tput smso
  printf "%s" "$*"
  tput rmso
}

U() {
  echo "$*" | awk '{print toupper($0)}'
}

c() {
  tput bold
  printf "%s" "$*"
  tput sgr0
}

init_workdir() {
  git clean -fdx $WORK_DIR
}

local_install() {
  local source=$1
  local dest=$2
  mkdir -p $LOCAL_DIR/$(dirname $dest)
  install $source $LOCAL_DIR/$dest
}

catalog() {
  local thingy=$1
  mkdir -p $LOCAL_DIR/catalog
  touch $LOCAL_DIR/catalog/$thingy
}


namespace=tap-install
is_cataloged() {
  local thingy=$1
  [ -f $LOCAL_DIR/catalog/$thingy ]
}

catalog_reset() {
  local thingy=$1
  rm -f $LOCAL_DIR/catalog/$thingy
}

ensure() {
  local thingy=$1
  if is_cataloged $thingy; then
    crumb "$thingy already setup"
    return
  fi
  bash $BASE_DIR/setup.sh $thingy
}

extract() {
  local source=$1
  [ $OS = darwin ] && xattr -d com.apple.quarantine $source
  tar xvf $source -C $WORK_DIR
}

resolve_kubernetes_vendor() {
  if [[ $KUBERNETES_VENDOR == detect ]]; then
    local nodes=$(kubectl get nodes | tail -1)
    case $nodes in
      gke*)
        KUBERNETES_VENDOR=gke
        ;;
      *)
        error "couldn't detect Kubernetes vendor: sample node below"
        echo "$nodes"
        die
        ;;
    esac
  fi
  crumb "Kubernetes vender is $KUBERNETES_VENDOR"
}
