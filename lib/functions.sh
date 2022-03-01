die() {
  [ $# -gt 0 ] && err "$*"
  exit 1
}

msg() {
  tput setaf 2
  echo "--- $*"
  tput sgr0
}

err() {
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
  mkdir -p $LOCAL_DIR/$(dirname $2)
  install $1 $LOCAL_DIR/$2
}

catalog() {
  mkdir -p $LOCAL_DIR/catalog
  touch $LOCAL_DIR/catalog/$1
}

is_cataloged() {
  [ -f $LOCAL_DIR/catalog/$1 ]
}

catalog_reset() {
  rm -f $LOCAL_DIR/catalog/$1
}

ensure() {
  is_cataloged $1 && return
  bash $BASE_DIR/bin/setup.sh $1
}
