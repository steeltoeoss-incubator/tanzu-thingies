set -ueo pipefail

source $PROFILE

message "starting a Minikube cluster"
catalog_reset minikube-cluster
minikube start \
  --cpus=$MINIKUBE_CPUS \
  --memory=$MINIKUBE_MEMORY \
  --disk-size=$MINIKUBE_DISK \
  --kubernetes-version=$MINIKUBE_KUBERNETES_VERSION \
  --driver=$MINIKUBE_DRIVER
echo
echo "to delete cluster, run:"
echo "    minikube delete"
catalog minikube-cluster
