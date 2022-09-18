#!/usr/bin/bash env

dist_dir=$1
env_file=./env
kubectl_cfg=kube-config

if [[ ! -d $dist_dir ]]; then
  echo "distribution dir does not exist: $dist_dir" >&2
  exit 1
fi

cd $dist_dir

if [[ ! -f $kubectl_cfg ]]; then
  echo "kubectl config does not exist: $kubectl_cfg" >&2
  exit 1
fi

sed -i 's/\r//' $env_file
source $env_file
export \
  INSTALL_BUNDLE INSTALL_\
  INSTALL_REGISTRY_HOSTNAME \
  INSTALL_REGISTRY_USERNAME \
  INSTALL_REGISTRY_PASSWORD

sed -i 's_C:_/mnt/c_' $kubectl_cfg
sed -i 's_\\_/_g' $kubectl_cfg

KUBECONFIG=$kubectl_cfg \
  ./install.sh --yes
