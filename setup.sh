#!/usr/bin/env bash

set -ueo pipefail

source $(dirname $0)/etc/profile.sh

usage() {
  cat <<EOF
$(b USAGE)
     $(c $PROG) thingy
     $(c $PROG) -h
     $(c $PROG) -l
$(b DESCRIPTION)
     Setup a Tanzu thingy.
$(b WHERE)
     thingy  thingy to setup
$(b OPTIONS)
     -h      print this message
     -l      list thingies
EOF
}

list_thingies() {
  local thingy
  for thingy in $THINGY_DIR/*; do
    thingy=$(basename $thingy)
    local about=
    [ -f $THINGY_DIR/$thingy/about ] && about=$(cat $THINGY_DIR/$thingy/about)
    printf "%-32s %s\n" "$(basename $thingy)" "$about"
  done
}

while getopts ":hl" opt; do
  case $opt in
    h)
      usage
      exit
      ;;
    l)
      list_thingies
      exit
      ;;
    :)
      die "-$OPTARG requires an argument; run with -h for help"
      ;;
    \?)
      die "invalid option -$OPTARG; run with -h for help"
      ;;
  esac
done
shift $(($OPTIND - 1))

[ $# -gt 0 ] || die "thingy not specified; run with -h for help"
thingy=$1
shift

[ $# -eq 0 ] || die "too many args; run with -h for help"

thingy_setup=$thingy/setup.sh
[ -f $thingy_setup ] || thingy_setup=$THINGY_DIR/$thingy_setup
[ -f $thingy_setup ] || die "no such thingy $thingy; run with -l to list thingies"

dependencies=$thingy/dependencies
if [ -f $dependencies ]; then
  for dependency in $(cat $dependencies); do
    ensure $dependency
  done
fi

exec bash $thingy_setup
