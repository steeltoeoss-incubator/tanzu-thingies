#!/usr/bin/env bash

set -ueo pipefail

source $(dirname $0)/../etc/profile.sh


usage() {
  cat <<EOF
$(b USAGE)
     $(c $PROG) tool
     $(c $PROG) -h
     $(c $PROG) -l
$(b DESCRIPTION)
     Setup a Tanzu tool.
$(b WHERE)
     tool    tool to setup
$(b OPTIONS)
     -h      print this message
     -l      list tools
EOF
}


list_tools() {
  local tool
  for tool in $TOOL_DIR/*; do
    tool=$(basename $tool)
    local about=
    [ -f $TOOL_DIR/$tool/about ] && about=$(cat $TOOL_DIR/$tool/about)
    printf "%-24s %s\n" "$(basename $tool)" "$about"
  done
}


while getopts ":hl" opt; do
  case $opt in
    h)
      usage
      exit
      ;;
    l)
      list_tools
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

[ $# -gt 0 ] || die "tool not specified; run with -h for help"
tool=$1
shift

[ $# -eq 0 ] || die "too many args; run with -h for help"

tool_setup=$tool/setup.sh
[ -f $tool_setup ] || tool_setup=$TOOL_DIR/$tool_setup
[ -f $tool_setup ] || die "no such tool $tool; run with -l to list tools"

exec bash $tool_setup
