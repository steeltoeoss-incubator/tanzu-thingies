set -ueo pipefail

source $(dirname $0)/../../etc/profile.sh

message "starting a Minikube cluster"

cpus=8
memory=8192
version=1.21.1
driver=hyperkit

catalog_reset minikube-cluster
crumb "minikube config cpus=$cpus,memory=$memory,version=$version,driver=$driver"
minikube start --cpus=$cpus --memory=$memory --kubernetes-version=$version --driver=$driver
catalog minikube-cluster
