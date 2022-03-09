set -ueo pipefail

#
# see: https://github.com/Tanzu-Solutions-Engineering/se-tap-bootcamps/tree/main/tap-up-and-running-bootcamp
#

source $PROFILE

message "starting a GKE cluster"

catalog_reset gke-cluster
export CLOUDSDK_CORE_PROJECT
GKE_VERSION=$(gcloud container get-server-config \
  --format="yaml(defaultClusterVersion)" \
  --region $GKE_REGION \
  | awk '/defaultClusterVersion:/ {print $2}')
gcloud beta container clusters create "$GKE_NAME" \
  --region $GKE_REGION \
  --node-locations $GKE_REGION-a \
  --cluster-version $GKE_VERSION \
  --release-channel "None" \
  --machine-type "$GKE_MACHINE" \
  --image-type "COS_CONTAINERD" \
  --disk-type "pd-standard" \
  --disk-size "100" \
  --metadata disable-legacy-endpoints=true \
  --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" \
  --max-pods-per-node "110" \
  --num-nodes "$GKE_NODES" \
  --logging=SYSTEM,WORKLOAD \
  --monitoring=SYSTEM \
  --enable-ip-alias \
  --network "projects/dotnet-developer-experience/global/networks/default" \
  --subnetwork "projects/dotnet-developer-experience/regions/${GKE_REGION}/subnetworks/default" \
  --no-enable-intra-node-visibility \
  --default-max-pods-per-node "110" \
  --no-enable-master-authorized-networks \
  --addons HorizontalPodAutoscaling,HttpLoadBalancing,GcePersistentDiskCsiDriver \
  --enable-autoupgrade \
  --enable-autorepair \
  --max-surge-upgrade 1 \
  --max-unavailable-upgrade 0 \
  --enable-shielded-nodes
catalog gke-cluster
