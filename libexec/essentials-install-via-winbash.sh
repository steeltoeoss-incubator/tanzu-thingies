#!/usr/bin/bash env

home=$1
dist_dir=$2

kube_config=$home/.kube/config
export KUBECONFIG=kube-config

if [[ ! -f $kube_config ]]; then
  echo "cannot find kubectl config: $kube_config" >&2
  exit 1
fi

cd $dist_dir

sed -i 's/\r//' ./env
source ./env
export \
  INSTALL_BUNDLE INSTALL_\
  INSTALL_REGISTRY_HOSTNAME \
  INSTALL_REGISTRY_USERNAME \
  INSTALL_REGISTRY_PASSWORD

sed -i 's_C:_/mnt/c_' $KUBECONFIG
sed -i 's_\\_/_g' $KUBECONFIG

./install.sh --yes
