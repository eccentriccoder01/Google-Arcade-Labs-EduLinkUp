#!/bin/bash
# EduLinkUp Jenkins on GKE Deployment Script

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

#----------------------------------------------------start--------------------------------------------------#

clear
echo "${YELLOW_TEXT}${BOLD_TEXT}╔══════════════════════════════════════════════════════════════════╗${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}║                   EDULINKUP LAB AUTOMATION                       ║${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}║              Launching Your Cloud Learning Journey...            ║${RESET_FORMAT}"
echo "${YELLOW_TEXT}${BOLD_TEXT}╚══════════════════════════════════════════════════════════════════╝${RESET_FORMAT}"
echo

# Function to set and export zone
set_zone() {
    echo "${BLUE_TEXT}${BOLD_TEXT}Zone Configuration${RESET_FORMAT}"
    
    # Try to get default zone
    export ZONE=$(gcloud config get-value compute/zone 2>/dev/null)
    
    if [ -z "$ZONE" ]; then
        echo "${YELLOW_TEXT}No default zone configured.${RESET_FORMAT}"
        echo "${CYAN_TEXT}Available zones in your project:${RESET_FORMAT}"
        gcloud compute zones list --format="value(name)" | sort | pr -3 -t
        
        while true; do
            read -p "${BOLD_TEXT}Enter your preferred zone (e.g., us-central1-a): ${RESET_FORMAT}" ZONE
            if gcloud compute zones describe $ZONE &>/dev/null; then
                break
            else
                echo "${RED_TEXT}Invalid zone. Please try again.${RESET_FORMAT}"
            fi
        done
        
        # Set zone in gcloud config
        gcloud config set compute/zone $ZONE
    fi
    
    echo "${GREEN_TEXT}Using zone: ${BOLD_TEXT}$ZONE${RESET_FORMAT}"
    export ZONE
}

# Set and export zone
set_zone

# Main execution
echo
echo "${MAGENTA_TEXT}${BOLD_TEXT}Starting Jenkins CD Deployment${RESET_FORMAT}"

echo "${CYAN_TEXT}${BOLD_TEXT}Step 1: Cloning CD on Kubernetes repository...${RESET_FORMAT}"
git clone https://github.com/GoogleCloudPlatform/continuous-deployment-on-kubernetes.git
cd continuous-deployment-on-kubernetes || exit

echo "${CYAN_TEXT}${BOLD_TEXT}Step 2: Creating GKE cluster for Jenkins...${RESET_FORMAT}"
gcloud container clusters create jenkins-cd \
--num-nodes 2 \
--scopes "https://www.googleapis.com/auth/projecthosting,cloud-platform" \
--zone $ZONE

echo "${CYAN_TEXT}${BOLD_TEXT}Step 3: Configuring kubectl credentials...${RESET_FORMAT}"
gcloud container clusters get-credentials jenkins-cd --zone $ZONE

echo "${CYAN_TEXT}${BOLD_TEXT}Step 4: Setting up Helm charts...${RESET_FORMAT}"
helm repo add jenkins https://charts.jenkins.io
helm repo update

echo "${CYAN_TEXT}${BOLD_TEXT}Step 5: Deploying Jenkins...${RESET_FORMAT}"
helm upgrade --install -f jenkins/values.yaml myjenkins jenkins/jenkins

# Completion message
echo
echo "${GREEN_TEXT}${BOLD_TEXT}Jenkins Deployment Completed Successfully${RESET_FORMAT}"
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
