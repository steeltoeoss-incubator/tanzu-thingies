set -ueo pipefail

source $(dirname $0)/../../etc/profile.sh

msg "starting a Minikube cluster"

set -x
catalog_reset minikube-cluster
minikube start --cpus=8 --memory=8192 --kubernetes-version=1.21.1 --driver=hyperkit
catalog minikube-cluster

