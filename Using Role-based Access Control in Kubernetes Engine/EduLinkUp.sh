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


BLINK_TEXT=$'\033[5m'
NO_COLOR=$'\033[0m'
RESET_FORMAT=$'\033[0m'
REVERSE_TEXT=$'\033[7m'

# Fetch zone and region
echo "${YELLOW}${BOLD}Fetching GCP configuration...${RESET}"
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)

echo "${GREEN}${BOLD}Current Configuration:${RESET}"
echo "Project ID: ${BLUE}$PROJECT_ID${RESET}"
echo "Region: ${BLUE}$REGION${RESET}"
echo "Zone: ${BLUE}$ZONE${RESET}"
echo

# Set GCP region and zone
echo "${YELLOW}${BOLD}Setting GCP configuration...${RESET}"
gcloud config set compute/region $REGION
gcloud config set compute/zone $ZONE

# Define instance and cluster variables
INSTANCE_NAME="gke-tutorial-admin"
CLUSTER_NAME="rbac-demo-cluster"
RBAC_MANIFEST_PATH="./manifests/rbac.yaml"

# Task 1: Configure admin instance
echo "${MAGENTA}${BOLD}Starting Task 1: Configuring admin instance...${RESET}"
gcloud compute ssh $INSTANCE_NAME --zone $ZONE --quiet --command "
  sudo apt-get update &&
  sudo apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin &&
  echo 'source ~/.bashrc' >> ~/.bash_profile &&
  source ~/.bash_profile &&
  gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE &&
  kubectl apply -f $RBAC_MANIFEST_PATH
"
echo "${GREEN}${BOLD}Task 1 completed successfully!${RESET}"
echo

# Task 2: Configure owner instance
INSTANCE_NAME2="gke-tutorial-owner"
echo "${MAGENTA}${BOLD}Starting Task 2: Configuring owner instance...${RESET}"
gcloud compute ssh $INSTANCE_NAME2 --zone $ZONE --command '
  sudo apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin &&
  echo "export USE_GKE_GCLOUD_AUTH_PLUGIN=True" >> ~/.bashrc &&
  source ~/.bashrc &&
  gcloud container clusters get-credentials '"$CLUSTER_NAME"' --zone '"$ZONE"' &&
  kubectl create -n dev -f ./manifests/hello-server.yaml &&
  kubectl create -n prod -f ./manifests/hello-server.yaml &&
  kubectl create -n test -f ./manifests/hello-server.yaml
'
echo "${GREEN}${BOLD}Task 2 completed successfully!${RESET}"
echo

# Task 3: Pod labeler configuration
echo "${MAGENTA}${BOLD}Starting Task 3: Pod labeler configuration...${RESET}"
gcloud compute ssh $INSTANCE_NAME --zone $ZONE --command "kubectl apply -f manifests/pod-labeler.yaml"

gcloud compute ssh "$INSTANCE_NAME" --zone "$ZONE" --command '
  kubectl get pod -o yaml -l app=pod-labeler &&
  kubectl apply -f manifests/pod-labeler-fix-1.yaml &&
  kubectl get deployment pod-labeler -o yaml &&
  kubectl get pods -l app=pod-labeler &&
  kubectl logs -l app=pod-labeler &&
  kubectl get rolebinding pod-labeler -o yaml &&
  kubectl get role pod-labeler -o yaml &&
  kubectl get rolebinding pod-labeler -oyaml &&
  kubectl get role pod-labeler -oyaml &&
  kubectl apply -f manifests/pod-labeler-fix-2.yaml
'

gcloud compute ssh "$INSTANCE_NAME" --zone "$ZONE" --command '
  kubectl get rolebinding pod-labeler -oyaml &&
  kubectl get role pod-labeler -oyaml &&
  kubectl apply -f manifests/pod-labeler-fix-2.yaml
'
echo "${GREEN}${BOLD}Task 3 completed successfully!${RESET}"
echo

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
