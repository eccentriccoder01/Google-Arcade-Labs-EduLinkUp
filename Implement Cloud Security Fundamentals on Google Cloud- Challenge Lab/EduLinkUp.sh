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


BLACK_TEXT=$'\033[0;90m'
RED_TEXT=$'\033[0;91m'
GREEN_TEXT=$'\033[0;92m'
YELLOW_TEXT=$'\033[0;93m'
BLUE_TEXT=$'\033[0;94m'
MAGENTA_TEXT=$'\033[0;95m'
CYAN_TEXT=$'\033[0;96m'
WHITE_TEXT=$'\033[0;97m'
TEAL=$'\033[38;5;50m'

BOLD_TEXT=$'\033[1m'
UNDERLINE_TEXT=$'\033[4m'
BLINK_TEXT=$'\033[5m'
NO_COLOR=$'\033[0m'
RESET_FORMAT=$'\033[0m'
REVERSE_TEXT=$'\033[7m'

# Prompt user to input three regions
read -p "${YELLOW_TEXT}${BOLD_TEXT}Enter CUSTOM_SECURIY_ROLE: ${RESET_FORMAT}" CUSTOM_SECURIY_ROLE
read -p "${YELLOW_TEXT}${BOLD_TEXT}Enter SERVICE_ACCOUNT: ${RESET_FORMAT}" SERVICE_ACCOUNT
read -p "${YELLOW_TEXT}${BOLD_TEXT}Enter CLUSTER_NAME: ${RESET_FORMAT}" CLUSTER_NAME
read -p "${YELLOW_TEXT}${BOLD_TEXT}Enter ZONE: ${RESET_FORMAT}" ZONE

echo ""
echo "${MAGENTA_TEXT}${BOLD_TEXT}Setting up your GCP environment...${RESET_FORMAT}"
echo ""

#Task 1:-
echo "${MAGENTA_TEXT}${BOLD_TEXT}Setting compute zone...${RESET_FORMAT}"
gcloud config set compute/zone $ZONE

echo "${MAGENTA_TEXT}${BOLD_TEXT}Creating role definition...${RESET_FORMAT}"
cat > role-definition.yaml <<EOF_END
title: "$CUSTOM_SECURIY_ROLE"
description: "Permissions"
stage: "ALPHA"
includedPermissions:
- storage.buckets.get
- storage.objects.get
- storage.objects.list
- storage.objects.update
- storage.objects.create
EOF_END

echo "${MAGENTA_TEXT}${BOLD_TEXT}Creating service account...${RESET_FORMAT}"
gcloud iam service-accounts create orca-private-cluster-sa --display-name "Orca Private Cluster Service Account"

echo "${MAGENTA_TEXT}${BOLD_TEXT}Creating custom role...${RESET_FORMAT}"
gcloud iam roles create $CUSTOM_SECURIY_ROLE --project $DEVSHELL_PROJECT_ID --file role-definition.yaml

#Task 2:-
echo "${MAGENTA_TEXT}${BOLD_TEXT}Creating main service account...${RESET_FORMAT}"
gcloud iam service-accounts create $SERVICE_ACCOUNT --display-name "Orca Private Cluster Service Account"

#Task 3:-
echo "${MAGENTA_TEXT}${BOLD_TEXT}Assigning IAM roles...${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}Adding monitoring.viewer role...${RESET_FORMAT}"
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member serviceAccount:$SERVICE_ACCOUNT@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role roles/monitoring.viewer

echo "${MAGENTA_TEXT}${BOLD_TEXT}Adding monitoring.metricWriter role...${RESET_FORMAT}"
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member serviceAccount:$SERVICE_ACCOUNT@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role roles/monitoring.metricWriter

echo "${MAGENTA_TEXT}${BOLD_TEXT}Adding logging.logWriter role...${RESET_FORMAT}"
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member serviceAccount:$SERVICE_ACCOUNT@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role roles/logging.logWriter

echo "${MAGENTA_TEXT}${BOLD_TEXT}Adding custom security role...${RESET_FORMAT}"
gcloud projects add-iam-policy-binding $DEVSHELL_PROJECT_ID --member serviceAccount:$SERVICE_ACCOUNT@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --role projects/$DEVSHELL_PROJECT_ID/roles/$CUSTOM_SECURIY_ROLE

#Task 4:-
echo "${MAGENTA_TEXT}${BOLD_TEXT}Creating GKE cluster...${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}This may take a few minutes...${RESET_FORMAT}"
gcloud container clusters create $CLUSTER_NAME --num-nodes 1 --master-ipv4-cidr=172.16.0.64/28 --network orca-build-vpc --subnetwork orca-build-subnet --enable-master-authorized-networks  --master-authorized-networks 192.168.10.2/32 --enable-ip-alias --enable-private-nodes --enable-private-endpoint --service-account $SERVICE_ACCOUNT@$DEVSHELL_PROJECT_ID.iam.gserviceaccount.com --zone $ZONE

#Task 5:-
echo "${MAGENTA_TEXT}${BOLD_TEXT}Configuring jumphost and deploying application...${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}Setting up Kubernetes resources...${RESET_FORMAT}"
gcloud compute ssh --zone "$ZONE" "orca-jumphost" --project "$DEVSHELL_PROJECT_ID" --quiet --command "gcloud config set compute/zone $ZONE && gcloud container clusters get-credentials $CLUSTER_NAME --internal-ip && sudo apt-get install -y google-cloud-sdk-gke-gcloud-auth-plugin && kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:1.0 && kubectl expose deployment hello-server --name orca-hello-service --type LoadBalancer --port 80 --target-port 8080"

# Final message
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
