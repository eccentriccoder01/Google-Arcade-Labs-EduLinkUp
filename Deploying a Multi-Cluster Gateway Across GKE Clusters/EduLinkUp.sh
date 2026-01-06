#!/bin/bash

# Define color variables
BLACK_TEXT=$'\033[0;90m'
RED_TEXT=$'\033[0;91m'
GREEN_TEXT=$'\033[0;92m'
YELLOW_TEXT=$'\033[0;93m'
BLUE_TEXT=$'\033[0;94m'
MAGENTA_TEXT=$'\033[0;95m'
CYAN_TEXT=$'\033[0;96m'
WHITE_TEXT=$'\033[0;97m'

NO_COLOR=$'\033[0m'
RESET_FORMAT=$'\033[0m'

# Define text formatting variables
BOLD_TEXT=$'\033[1m'
UNDERLINE_TEXT=$'\033[4m'

clear

# Welcome message
echo "${YELLOW_TEXT}${BOLD_TEXT}╔══════════════════════════════════════════════════════════════════╗${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}║                   EDULINKUP LAB AUTOMATION                       ║${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}║              Launching Your Cloud Learning Journey...            ║${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}╚══════════════════════════════════════════════════════════════════╝${RESET_FORMAT}"
echo


# Ask for three zones from user
read -p "Enter zone for cluster1 (e.g., us-central1-a): " ZONE1
read -p "Enter zone for cluster2 (e.g., us-central1-b): " ZONE2
read -p "Enter zone for cluster3 (e.g., us-east1-b): " ZONE3

# Derive region for each zone
REGION1="${ZONE1%-*}"
REGION2="${ZONE2%-*}"
REGION3="${ZONE3%-*}"

echo "Cluster1: zone=$ZONE1, region=$REGION1"
echo "Cluster2: zone=$ZONE2, region=$REGION2"
echo "Cluster3: zone=$ZONE3, region=$REGION3"

# Get project details
PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format="value(projectNumber)")

# Enable Anthos API (GKE Enterprise)
gcloud services enable anthos.googleapis.com --project="$PROJECT_ID"
gcloud container fleet create --display-name=gke-enterprise-fleet --project="$PROJECT_ID"

# Create clusters
gcloud container clusters create cluster1 \
  --zone="$ZONE1" \
  --enable-ip-alias \
  --machine-type=e2-standard-4 \
  --num-nodes=1 \
  --workload-pool="${PROJECT_ID}.svc.id.goog" \
  --release-channel=regular \
  --project="$PROJECT_ID" --async

gcloud container clusters create cluster2 \
  --zone="$ZONE2" \
  --enable-ip-alias \
  --machine-type=e2-standard-4 \
  --num-nodes=1 \
  --workload-pool="${PROJECT_ID}.svc.id.goog" \
  --release-channel=regular \
  --project="$PROJECT_ID" --async

gcloud container clusters create cluster3 \
  --zone="$ZONE3" \
  --enable-ip-alias \
  --machine-type=e2-standard-4 \
  --num-nodes=1 \
  --workload-pool="${PROJECT_ID}.svc.id.goog" \
  --release-channel=regular \
  --project="$PROJECT_ID"

# Wait until clusters are up (prints status)
echo "Waiting for clusters to be provisioned..."
gcloud container clusters list

# Get credentials and rename contexts
gcloud container clusters get-credentials cluster1 --zone="$ZONE1" --project="$PROJECT_ID"
gcloud container clusters get-credentials cluster2 --zone="$ZONE2" --project="$PROJECT_ID"
gcloud container clusters get-credentials cluster3 --zone="$ZONE3" --project="$PROJECT_ID"

kubectl config rename-context "gke_${PROJECT_ID}_${ZONE1}_cluster1" cluster1
kubectl config rename-context "gke_${PROJECT_ID}_${ZONE2}_cluster2" cluster2
kubectl config rename-context "gke_${PROJECT_ID}_${ZONE3}_cluster3" cluster3

# Enable Gateway API on cluster1
gcloud container clusters update cluster1 --gateway-api=standard --zone="$ZONE1" --project="$PROJECT_ID"

# Register clusters to fleet
gcloud container fleet memberships register cluster1 \
  --gke-cluster "$ZONE1"/cluster1 \
  --enable-workload-identity \
  --project="$PROJECT_ID"

gcloud container fleet memberships register cluster2 \
  --gke-cluster "$ZONE2"/cluster2 \
  --enable-workload-identity \
  --project="$PROJECT_ID"

gcloud container fleet memberships register cluster3 \
  --gke-cluster "$ZONE3"/cluster3 \
  --enable-workload-identity \
  --project="$PROJECT_ID"

gcloud container fleet memberships list --project="$PROJECT_ID"

# Enable Multi-cluster Services (MCS)
gcloud container fleet multi-cluster-services enable --project "$PROJECT_ID"

# IAM for MCS
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member "serviceAccount:${PROJECT_ID}.svc.id.goog[gke-mcs/gke-mcs-importer]" \
  --role "roles/compute.networkViewer" \
  --project="$PROJECT_ID"

gcloud container fleet multi-cluster-services describe --project="$PROJECT_ID"

# Enable Multi-cluster Gateway (MCG) controller on cluster1
gcloud container fleet ingress enable \
  --config-membership=cluster1 \
  --project="$PROJECT_ID" \
  --location="$REGION1"

gcloud container fleet ingress describe --project="$PROJECT_ID"

# Grant IAM for Gateway controller
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
  --member "serviceAccount:service-${PROJECT_NUMBER}@gcp-sa-multiclusteringress.iam.gserviceaccount.com" \
  --role "roles/container.admin" \
  --project="$PROJECT_ID"

echo "Script completed setup for clusters and controllers. Proceed with application YAML deployments as per your lab."

# Final message
echo
echo "${GREEN_TEXT}${BOLD_TEXT}╔══════════════════════════════════════════════════════════════════╗${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}║                   LAB COMPLETED SUCCESSFULLY!                    ║${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}╚══════════════════════════════════════════════════════════════════╝${RESET_FORMAT}"
echo
echo "${MAGENTA_TEXT}${BOLD_TEXT}📺 SUBSCRIBE TO EDULINKUP FOR MORE CLOUD LABS! 📺${RESET_FORMAT}"
echo "${CYAN_TEXT}${BOLD_TEXT}${UNDERLINE_TEXT}🔗 https://www.youtube.com/@EduLinkUp${RESET_FORMAT}"
echo "${BLUE_TEXT}${BOLD_TEXT}💡 Keep Learning, Keep Growing! 💡${RESET_FORMAT}"
echo
