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


# Bright Foreground Colors
BRIGHT_BLACK_TEXT=$'\033[0;90m'
BRIGHT_RED_TEXT=$'\033[0;91m'
BRIGHT_GREEN_TEXT=$'\033[0;92m'
BRIGHT_YELLOW_TEXT=$'\033[0;93m'
BRIGHT_BLUE_TEXT=$'\033[0;94m'
BRIGHT_MAGENTA_TEXT=$'\033[0;95m'
BRIGHT_CYAN_TEXT=$'\033[0;96m'
BRIGHT_WHITE_TEXT=$'\033[0;97m'

NO_COLOR=$'\033[0m'
RESET_FORMAT=$'\033[0m'
BOLD_TEXT=$'\033[1m'

# Fetch zone and region
ZONE=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-zone])")
REGION=$(gcloud compute project-info describe \
  --format="value(commonInstanceMetadata.items[google-compute-default-region])")
PROJECT_ID=$(gcloud config get-value project)

gcloud config set compute/zone $ZONE

gcloud container clusters create io --zone $ZONE

gcloud storage cp -r gs://spls/gsp021/* .

cd orchestrate-with-kubernetes/kubernetes

kubectl create deployment nginx --image=nginx:1.27.0

kubectl get pods

kubectl expose deployment nginx --port 80 --type LoadBalancer

kubectl get services

cd ~/orchestrate-with-kubernetes/kubernetes

kubectl create -f pods/fortune-app.yaml

kubectl create secret generic tls-certs --from-file tls/  
kubectl create configmap nginx-proxy-conf --from-file nginx/proxy.conf  
kubectl create -f pods/secure-fortune.yaml

kubectl create -f services/fortune-app.yaml

gcloud compute firewall-rules create allow-fortune-nodeport --allow tcp:31000

kubectl get pods -l "app=fortune-app"

kubectl get pods -l "app=fortune-app,secure=enabled"

kubectl label pods secure-fortune 'secure=enabled'
kubectl get pods secure-fortune --show-labels

kubectl create -f deployments/auth.yaml

kubectl create -f services/auth.yaml

kubectl create -f deployments/fortune-service.yaml
kubectl create -f services/fortune-service.yaml

kubectl create configmap nginx-frontend-conf --from-file=nginx/frontend.conf  
kubectl create -f deployments/frontend.yaml  
kubectl create -f services/frontend.yaml

kubectl get services frontend

echo
echo "${GREEN_TEXT}${BOLD_TEXT}=======================================================${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}              LAB COMPLETED SUCCESSFULLY!                 ${RESET_FORMAT}"
echo "${GREEN_TEXT}${BOLD_TEXT}=======================================================${RESET_FORMAT}"

echo
echo "${GREEN_TEXT}${BOLD_TEXT}${UNDERLINE_TEXT}https://www.youtube.com/@EduLinkUp${RESET_FORMAT}"
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
