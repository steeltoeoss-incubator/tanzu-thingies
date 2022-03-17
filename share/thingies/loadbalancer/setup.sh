set -ueo pipefail

source $PROFILE

message "setting up a LoadBalancer"

catalog_reset loadbalancer
crumb "deploying contour"
kubectl apply -f https://projectcontour.io/quickstart/contour.yaml
catalog loadbalancer
